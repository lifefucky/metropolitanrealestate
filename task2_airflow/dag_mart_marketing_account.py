from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 4, 14),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'execution_timeout': timedelta(hours=1)
}

dag = DAG(
    'marketing_account',
    default_args=default_args,
    description='DAG for updating mart_data.marketing_account',
    tags=['MART'],
    schedule_interval='0 3 * * *'
)
'''
Таска, которая создает таблички, предоставленные в примере
'''
'''
create_tables = BigQueryOperator(
    task_id='create_source_tables',
    sql='create_tables.sql',
    dag=dag
)
'''
update_mart = BigQueryOperator(
    task_id='update_mart',
    sql='fill_mart.sql',
    dag=dag
)
'''
create_tables >> update_mart
'''
update_vitrine
