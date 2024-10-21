from fastapi import FastAPI
import uvicorn
import pendulum


app = FastAPI()


@app.get("/")
async def index():
    return {
        "now": pendulum.now(tz='UTC').format('YYYY-MM-DD HH:mm:ss z'),
    }


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
