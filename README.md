Прокси сервер
=============================

Установка
------------
Команды для запуска проекткта:
   
    docker-compose up -d                                        - Запустить контейнеры    

Пример использования
-----------
    Генерим сертификаты один раз в три года и кладем в проект.
    http://r-notes.ru/administrirovanie/poleznosti/164-openssl-sozdanie-multidomennogo-sertifikata.html   
    
    cd ssl && ./generate_ssl.sh local.dv    
    Для того чтобы расшарить сертификат на домены 3 уровня например api.<поддомен>.local.dv
    cd ssl && ./generate_ssl.sh <поддомен>.local.dv
        
    
    Тому кто скачал себе проект необходимо добавить в браузер сертификат
    Добавляем в браузер ssl/dhparam/local.dv.pem
    Добавляем в браузер ssl/dhparam/<поддомен>.dv.pem - для поддоменов с 3 уровнями если есть
    chrome://flags/#allow-insecure-localhost
    
    В другом прокте на докере указываем переменные окружения в файле .env
    
    #dev/local settings        
    DOCKER_SITE_URL=orion.local.dv
    DOCKER_DATABASE_PORT=5432
    REDIRECT_HTTPS=true
