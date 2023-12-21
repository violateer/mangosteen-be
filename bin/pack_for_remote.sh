# 注意修改 user 和 ip
user=root
ip=8.140.248.183
port=3122

time=$(date +'%Y%m%d-%H%M%S')
cache_dir=tmp/deploy_cache
dist=$cache_dir/mangosteen-$time.tar.gz
current_dir=$(dirname $0)
deploy_dir=/home/mangosteen/deploys/$time
gemfile=$current_dir/../Gemfile
gemfile_lock=$current_dir/../Gemfile.lock
vendor_dir=$current_dir/../vendor
vendor_1=rspec_api_documentation
api_dir=$current_dir/../doc/api 

function title {
  echo 
  echo "###############################################################################"
  echo "## $1"
  echo "###############################################################################" 
  echo 
}


mkdir -p $cache_dir
title '打包源代码'
tar --exclude="tmp/cache/*" --exclude="tmp/deploy_cache/*" --exclude="vendor/*" -cz -f $dist *
title "打包本地依赖 ${vendor_1}"
bundle cache --quiet
tar -cz -f "$vendor_dir/cache.tar.gz" -C ./vendor cache
tar -cz -f "$vendor_dir/$vendor_1.tar.gz" -C ./vendor $vendor_1
title '创建远程目录'
ssh -p $port $user@$ip "mkdir -p $deploy_dir/vendor"
title '上传源代码和依赖'
scp -P $port $dist $user@$ip:$deploy_dir/
yes | rm $dist
scp -P $port $gemfile $user@$ip:$deploy_dir/
scp -P $port $gemfile_lock $user@$ip:$deploy_dir/
scp -P $port  -r $vendor_dir/cache.tar.gz $user@$ip:$deploy_dir/vendor/
yes | rm $vendor_dir/cache.tar.gz
scp -P $port  -r $vendor_dir/$vendor_1.tar.gz $user@$ip:$deploy_dir/vendor/
yes | rm $vendor_dir/$vendor_1.tar.gz
title '上传 Dockerfile'
scp -P $port $current_dir/../config/host.Dockerfile $user@$ip:$deploy_dir/Dockerfile
title '上传 nginx 配置文件'
scp -P $port $current_dir/nginx.conf $user@$ip:$deploy_dir/nginx.conf
title '上传 setup 脚本'
scp -P $port $current_dir/setup_remote.sh $user@$ip:$deploy_dir/
title '上传 API 文档'
scp -P $port -r $api_dir $user@$ip:$deploy_dir/
title '上传版本号'
ssh -p $port $user@$ip "echo $time > $deploy_dir/version"
title '执行远程脚本'
ssh -p $port $user@$ip "export version=$time; /bin/bash $deploy_dir/setup_remote.sh"
