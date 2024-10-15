from fastapi import FastAPI
from pydantic import BaseModel
import pymysql
from typing import Optional

app = FastAPI()

# Your db.py code imported here or can be refactored into a function
def execute_query(query: str):
    try:
        connection = pymysql.connect(
            host='host_ip_address', # update with ip address
            user='username',        # update with username
            password='password',    # update with password
            db='database'           # update with database
        )
        print("Connection established")
        with connection.cursor() as cursor:
            cursor.execute(query)
            result = cursor.fetchall()  # Fetch all the results

        return {
            "result": result
        }
    except Exception as e:
        return {
            "error": f"Failed to connect to the database: {str(e)}"
        }
    finally:
        connection.close()

# Define a model for user input if required (for POST request use cases)
class QueryModel(BaseModel):
    query: Optional[str] = "SELECT student_name FROM students WHERE grade = 10 ORDER BY marks DESC LIMIT 1;"

@app.get("/query")
def run_query(query: str = "SELECT student_name FROM students WHERE grade = 10 ORDER BY marks DESC LIMIT 1;"):
    """
    API endpoint to run a SQL query.
    Example usage: http://127.0.0.1:8000/query?query=<YOUR_SQL_QUERY>
    """
    result = execute_query(query)
    return result

# For POST request if needed
@app.post("/execute")
def execute_post_query(query: QueryModel):
    """
    API endpoint to run a SQL query using POST.
    Example usage: http://127.0.0.1:8000/execute with {"query": "<YOUR_SQL_QUERY>"}
    """
    result = execute_query(query.query)
    return result



if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)