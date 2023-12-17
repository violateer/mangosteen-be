# README

## 1. 启动数据库

```
-- 首次运行
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

## 4. 创建/修改加密文件

```
EDITOR="code --wait" bin/rails credentials:edit

## 生成环境：
EDITOR="code --wait" bin/rails credentials:edit --environment production
```

## 5. 查看密钥

```
bin/rails console

Rails.application.credentials.config

```

## n. 待定

- 实现 refresh_token
