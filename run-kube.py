import os
import random
import subprocess
import multiprocessing
import re
import base64
import time


def clean_text(text: str) -> str:
    # Remove lines that start with ISO timestamp
    text = re.sub(
        r"^.*2026-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+Z.*\n?",
        "",
        text,
        flags=re.MULTILINE,
    )

    # Remove <tool_call>...</tool_call> blocks (including tags)
    text = re.sub(r"<tool_call>.*?</tool_call>", "", text, flags=re.DOTALL)

    return text


def run(query: str) -> str:
    query = query.replace("-", " ")  # uhh something about the text inject bugged
    print("query\n" + 30 * "===" + "\n", query, "\n")
    name = f"uxa-{random.randbytes(8).hex()}"
    pod = f"{name}-uxa-job"
    b64 = base64.b64encode(query.encode()).decode()
    subprocess.run(
        f"helm upgrade -i {name} ./charts/uxa-job "
        '--set uxaConfig.apiKey="$ZEROCLAW_API_KEY" '
        f'--set uxaConfig.query="$(echo {b64} | base64 -d)"',
        shell=True,
    )
    subprocess.run(
        f"kubectl wait --for=condition=Ready pod/{pod} --timeout=60000s", shell=True
    )
    result = subprocess.run(
        f"kubectl exec {pod} -- curl -s http://localhost:8000",
        capture_output=True,
        text=True,
        shell=True,
    )
    print(
        "RESULT\n" + "===" * 30 + "\n",
        result.stdout,
        "\n" + "===" * 30 + "\n",
        clean_text(result.stdout),
        "\n" + "===" * 30 + "\n",
    )
    subprocess.run(f"helm uninstall {name}", shell=True)
    return clean_text(result.stdout)


if __name__ == "__main__":
    if os.environ.get("ZEROCLAW_API_KEY") is None:
        print("You should set the ZEROCLAW_API_KEY env var.")
        exit(1)
    if os.environ.get("KUBECONFIG") is None:
        print("You should set the KUBECONFIG env var.")
        exit(1)

    # prompt = input(">>> ")
    prompt = input("website: ")
    if not prompt.startswith("<<<"):  # scuffed manual override
        prompt = (
            "You are a QA UX tester. "
            "Interact and explore my website using agent-browser "
            "and provide detailed feedback. " + prompt
        )
    with multiprocessing.Pool(10) as pool:
        results = pool.map(run, [prompt for _ in range(3)])

    allresults = "\n;;;\n".join(results)

    result = run(f"# Summarize the following:\n;;;\n{allresults}")
    time.sleep(1)
    print("\n\n\n", result)
