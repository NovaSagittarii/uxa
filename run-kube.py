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

    return text.strip()


def run(query: str) -> str:
    query = query.replace("-", " ")  # uhh something about the text inject bugged
    print("query\n" + 30 * "===" + "\n", query, "\n")
    name = f"uxa-{random.randbytes(8).hex()}"
    pod = f"{name}-uxa-job"
    for _ in range(9):  # light-retry (if no response)
        b64 = base64.b64encode(query.replace('"', '\\"').encode()).decode()
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
        out = clean_text(result.stdout).strip()
        if out:
            return out

    return ""


if __name__ == "__main__":
    if os.environ.get("ZEROCLAW_API_KEY") is None:
        print("You should set the ZEROCLAW_API_KEY env var.")
        exit(1)
    if os.environ.get("KUBECONFIG") is None:
        print("You should set the KUBECONFIG env var.")
        exit(1)

    import streamlit as st

    url = st.text_input("website to check")
    if url.startswith("<<<"):  # scuffed manual override
        prompt = url
    else:
        prompt = (
            "You are a QA UX tester. "
            "Interact and explore my website using agent-browser "
            "and provide detailed feedback. " + url
        )

    concur = st.number_input("concurrency", value=10, min_value=1, max_value=20)
    runs = st.number_input("runs", value=3, min_value=1, max_value=20)

    if st.button(f"Check {url}"):
        with st.spinner("Running...", show_time=True):
            with multiprocessing.Pool(concur) as pool:
                results = pool.map(run, [prompt for _ in range(runs)])

        allresults = "\n;;;\n".join(results)
        with st.expander(label="Individual reports"):
            for x in results:
                st.write(x)

        with st.spinner("Summarizing...", show_time=True):
            result = run(f"# Summarize the following:\n;;;\n{allresults}")
        st.write(result)
