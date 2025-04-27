# 图片转插画网站部署指南

本文档提供部署图片转插画网站到不同平台的详细步骤。

## 部署到Vercel（推荐）

Vercel是一个免费且易于使用的平台，特别适合Node.js应用的部署。

### 准备工作

1. 在[Vercel](https://vercel.com/)创建一个账户
2. 安装Vercel CLI（可选）：`npm install -g vercel`

### 部署步骤

#### 方法1：通过GitHub部署（推荐）

1. 将项目代码推送到GitHub仓库
2. 登录Vercel账户
3. 点击"New Project"按钮
4. 选择您的GitHub仓库
5. 保持默认设置，点击"Deploy"按钮
6. 等待部署完成，Vercel会提供一个URL（例如：your-project.vercel.app）

#### 方法2：通过Vercel CLI部署

1. 在项目根目录中打开终端
2. 运行`vercel login`，按照提示登录
3. 运行`vercel`命令
4. 按照提示选择配置（大多数情况下保持默认即可）
5. 等待部署完成，Vercel会提供一个URL

### 注意事项

- Vercel的免费计划有一些限制，如存储空间和带宽限制
- 由于Vercel是无服务器平台，文件上传会暂时存储，但不是永久性的
- 对于生产环境，建议使用外部存储服务如AWS S3来存储上传的图片和转换结果

## 部署到自己的服务器

如果您希望拥有完全的控制权，可以将应用部署到自己的服务器。

### 要求

- Node.js 14.0+
- npm 6.0+
- 足够的存储空间用于保存上传的图片和转换结果

### 部署步骤

1. 将项目代码传输到服务器（使用git clone、SFTP或其他方法）
2. 在服务器上安装依赖：
   ```bash
   npm install
   ```
3. 建议使用PM2来管理Node.js应用：
   ```bash
   npm install -g pm2
   pm2 start server.js --name "illustration-converter"
   ```
4. 配置反向代理（例如Nginx）来提供更好的性能和安全性：

   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

5. 配置SSL证书（推荐使用Let's Encrypt）

### 持久存储配置

为了长期存储上传的文件和转换结果，您需要：

1. 创建永久存储目录：
   ```bash
   mkdir -p /var/www/illustration-converter/uploads
   mkdir -p /var/www/illustration-converter/models
   mkdir -p /var/www/illustration-converter/outputs
   ```

2. 修改server.js以使用这些目录，或使用软链接

## 使用Docker部署

Docker提供了更简单的方式来部署应用，确保环境一致性。

### 准备工作

1. 在服务器上安装Docker
2. 创建Dockerfile（已包含在项目中）

### 部署步骤

1. 构建Docker镜像：
   ```bash
   docker build -t illustration-converter .
   ```

2. 运行容器：
   ```bash
   docker run -d -p 3000:3000 -v uploads:/app/uploads -v models:/app/models -v outputs:/app/public/outputs --name illustration-converter illustration-converter
   ```

3. 应用将在http://your-server-ip:3000上运行

## 配置域名

无论您选择哪种部署方式，配置自定义域名的步骤如下：

1. 购买域名（例如通过Namecheap、GoDaddy等）
2. 在DNS设置中添加A记录，指向您的服务器IP或平台提供的IP
3. 如果使用Vercel，可以在Vercel项目设置中添加自定义域名
4. 配置SSL证书以启用HTTPS（Vercel会自动处理这一步）

## 监控和维护

一旦部署完成，您应该：

1. 定期备份上传的数据
2. 监控服务器负载和资源使用情况
3. 设置错误日志监控
4. 定期检查和清理临时文件

## 故障排除

- 如果网站不可访问，检查服务器防火墙设置
- 如果上传失败，检查文件权限和存储空间
- 对于Vercel部署，查看部署日志以识别任何构建错误 