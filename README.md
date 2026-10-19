# Práctica LI16 con Apache Hive

Este proyecto reutiliza la configuración de HDFS del trabajo anterior con Apache Pinot. Aquí Hive lee y consulta un CSV de Facebook guardado en HDFS; Pinot no participa en estas consultas.

## Ejecutar

```bash
./scripts/preparar-datos.sh
./scripts/cargar-datos.sh
docker exec -it li16-hiveserver2 beeline -u 'jdbc:hive2://localhost:10000/default'
```

En Beeline se pueden ejecutar las consultas de [`sql/consultas.sql`](sql/consultas.sql). La interfaz del NameNode está en <http://localhost:9872/>.

Para mostrar una consulta con la hora actual en la terminal: `./scripts/consulta.sh 1` (números del 1 al 7).

El dataset se descarga de la [fuente educativa original de Udacity](https://s3.amazonaws.com/udacity-hosted-downloads/ud651/pseudo_facebook.tsv) y se convierte localmente a CSV sin encabezado; no se publica en el repositorio. El laboratorio también lo referencia mediante [Kaggle](https://www.kaggle.com/code/youssefabdelghfar/facebook-data-analysis/input).

Para detener los servicios: `docker compose down`. Los volúmenes conservan los datos.
