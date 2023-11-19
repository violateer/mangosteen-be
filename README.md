# README

## 1. 启动数据库

```
docker run -d      --name db-for-mangosteen      -e POSTGRES_USER=mangosteen      -e POSTGRES_PASSWORD=123456      -e POSTGRES_DB=mangosteen_dev      -e PGDATA=/var/lib/postgresql/data/pgdata      -v mangosteen-data:/var/lib/postgresql/data      --network=network1      postgres:14

-- 不是首次则运行下面的
docker start db-for-mangosteen
```

## 2. 启动 ruby 服务

```
bundle exe rails s

-- 或者

bin/rails s
```

## 3. ruby formatter 验证中文

- 文件首行添加 `# encoding: utf-8`
