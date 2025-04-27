FROM node:18-alpine

WORKDIR /app

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install --production

# 复制项目文件
COPY . .

# 创建必要的目录
RUN mkdir -p uploads models public/outputs

# 暴露3000端口
EXPOSE 3000

# 启动应用
CMD ["node", "server.js"] 