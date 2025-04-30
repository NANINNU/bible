# bible

This is a develop project about bible application.

Data of bible will get from GODpia.(i will crolling this page.)

the way of crolling is this url.(https://m.blog.naver.com/hiddenjgrace/222675096653?recommendTrackingCode=2)



## Getting Started




## Codebase 
### it will be updated...
```bash
< PROJECT ROOT >
   |
   |-- core/                 # Project Settings 
   |    |-- settings.py 
   |    |-- wsgi.py     
   |    |-- urls.py     
   |
   |-- home/                 # Presentation app 
   |    |-- views.py         # serve the HOMEpage  
   |    |-- urls.py     
   |    |-- models.py
   |
   |-- apps/                 # Utility Apps 
   |    |-- common/          # defines models & helpers
   |    |    |-- models.py   
   |    |    |-- util.py 
   |    |-- users            # Handles Authentication 
   |    |-- api              # DRF managed API
   |    |-- charts           # Showcase Different Charts
   |    |-- tables           # Implements DataTables
   |    |-- tasks            # Celery, async processing
   |
   |-- templates/            # UI templates 
   |-- static/               # Tailwind/Flowbite 
   |    |-- src/             # 
   |         |-- input.css   # CSS Styling
   |
   |-- Dockerfile            # Docker
   |-- docker-compose.yml    # Docker 
   |
   |-- render.yml            # CI/CD for Render
   |-- build.sh              # CI/CD for Render 
   |
   |-- manage.py             # Django Entry-Point
   |-- requirements.txt      # dependencies
   |-- .env                  # ENV File
   |
   |-- *************************************************      
```   

<br />
