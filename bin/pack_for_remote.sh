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
vendor_cache_dir=$current_dir/../vendor/cache

function title {
  echo 
  echo "###############################################################################"
  echo "## $1"
  echo "###############################################################################" 
  echo 
}


title '打包源代码为压缩文件'
mkdir $cache_dir
bundle cache
tar --exclude="tmp/cache/*" --exclude="tmp/deploy_cache/*" -czv -f $dist *
title '创建远程目录'
ssh -p $port $user@$ip "mkdir -p $deploy_dir/vendor"
title '上传压缩文件'
scp -P $port $dist $user@$ip:$deploy_dir/
yes | rm $dist
scp -P $port $gemfile $user@$ip:$deploy_dir/
scp -P $port $gemfile_lock $user@$ip:$deploy_dir/
scp -P $port -r $vendor_cache_dir $user@$ip:$deploy_dir/vendor/
title '上传 Dockerfile'
scp -P $port $current_dir/../config/host.Dockerfile $user@$ip:$deploy_dir/Dockerfile
title '上传 setup 脚本'
scp -P $port $current_dir/setup_remote.sh $user@$ip:$deploy_dir/
title '上传版本号'
ssh -p $port $user@$ip "echo $time > $deploy_dir/version"
title '执行远程脚本'
ssh -p $port $user@$ip "export version=$time; /bin/bash $deploy_dir/setup_remote.sh"
