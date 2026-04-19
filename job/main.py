from flask import Flask
import os
import signal

app = Flask(__name__)


@app.route("/")
def read_out() -> str:
    with open("out.txt") as f:
        txt = f.read()
    return txt


@app.route("/err")
def read_err() -> str:
    with open("err.txt") as f:
        txt = f.read()
    return txt


@app.route("/shutdown")
def shutdown() -> str:
    """closes server, allows for task cleanup"""
    os.kill(os.getpid(), signal.SIGINT)
    return "Shutting down."


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
