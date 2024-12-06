import boto3
import csv
import pymysql  
import os

Configurações do banco de dados RDS
DB_HOST = os.environ['DB_HOST']
DB_USER = os.environ['DB_USER']
DB_PASSWORD = os.environ['DB_PASSWORD']
DB_NAME = os.environ['DB_NAME']

# Inicializa o cliente do S3
s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Extrai informações do evento S3
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']

        try:
            # Faz download do arquivo CSV
            response = s3.get_object(Bucket=bucket_name, Key=object_key)
            content = response['Body'].read().decode('utf-8').splitlines()
            
            # Conta as linhas do CSV
            csv_reader = csv.reader(content)
            row_count = sum(1 for row in csv_reader)

            #Salva informações no RDS
            save_to_rds(object_key, row_count)

            print(f"Arquivo {object_key} processado com sucesso. Total de linhas: {row_count}")
        
        except Exception as e:
            print(f"Erro ao processar o arquivo {object_key}: {str(e)}")

def save_to_rds(file_name, row_count):
    try:
        # Conexão ao banco de dados RDS
        connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        cursor = connection.cursor()

        # Insere os dados no banco
        sql = "INSERT INTO file_metadata (file_name, row_count) VALUES (%s, %s)"
        cursor.execute(sql, (file_name, row_count))
        connection.commit()

        print(f"Dados salvos no RDS: {file_name}, {row_count}")
    
    except Exception as e:
        print(f"Erro ao salvar dados no RDS: {str(e)}")
    
    finally:
        if connection:
            connection.close()
