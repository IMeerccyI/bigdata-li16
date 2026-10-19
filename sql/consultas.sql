-- 1. Total de usuarios.
SELECT COUNT(*) AS total_usuarios FROM db_nelson.fb_nelson;

-- 2. Usuarios mayores de 25 años.
SELECT COUNT(*) AS mayores_25 FROM db_nelson.fb_nelson WHERE age > 25;

-- 3. Promedio de amigos por género; excluye género ausente.
SELECT gender, COUNT(*) AS usuarios, ROUND(AVG(friend_count), 2) AS promedio_amigos
FROM db_nelson.fb_nelson
WHERE gender IN ('male', 'female')
GROUP BY gender;

-- 4. Me gusta recibidos por jóvenes y mayores.
SELECT CASE WHEN age BETWEEN 13 AND 25 THEN '13-25'
            WHEN age > 35 THEN '36+'
       END AS grupo_edad,
       COUNT(*) AS usuarios,
       SUM(likes_received) AS total_me_gusta_recibidos,
       ROUND(AVG(likes_received), 2) AS promedio_por_usuario
FROM db_nelson.fb_nelson
WHERE age BETWEEN 13 AND 25 OR age > 35
GROUP BY CASE WHEN age BETWEEN 13 AND 25 THEN '13-25' WHEN age > 35 THEN '36+' END;

-- 5. Usuarios por mes de cumpleaños.
SELECT dob_month, COUNT(*) AS usuarios
FROM db_nelson.fb_nelson
GROUP BY dob_month
ORDER BY dob_month;

-- 6. Me gusta desde celular y web entre jóvenes.
SELECT COUNT(*) AS usuarios,
       SUM(mobile_likes) AS me_gusta_celular,
       SUM(www_likes) AS me_gusta_web
FROM db_nelson.fb_nelson
WHERE age BETWEEN 13 AND 25;

-- 7. Me gusta desde celular y web entre adultos.
SELECT COUNT(*) AS usuarios,
       SUM(mobile_likes) AS me_gusta_celular,
       SUM(www_likes) AS me_gusta_web
FROM db_nelson.fb_nelson
WHERE age > 25;
