# Sample configuration

Configuration of my cluster, it prepares, updates and deploys my app. Maybe maybe it will be also usefull for Yours, also it can be used as a sample usage of [Vfs][vfs], [Vos][vos] and [ClusterManagement][cluster_management] tools.

It's not only automate the deployment process, it fully configure servers, see below.

Here's how I'm using it, let's say I want to deploy my app to clean box(es) with remote ssh access, all I need to do - type:

``` bash
rake deploy
```

It's clever ennought to determine that before deploying app it needs to prepare clean box, and It will:

- install & configure: git, mail, ruby, mongodb, nginx
- ensure that mongodb and nginx is running
- only then it will deploy the application

Sample output:

```
installing :os to my.aws.amazon.com
installing :system_tools to my.aws.amazon.com
installing :ruby to my.aws.amazon.com
  building
  configuring
  updating environment
installing :git to my.aws.amazon.com
installing :security to my.aws.amazon.com
installing :manual_management to my.aws.amazon.com
installing :fake_gem to my.aws.amazon.com
installing :custom_ruby to my.aws.amazon.com
  fake_gem env
  rspec
installing :fs to my.aws.amazon.com
installing :thin to my.aws.amazon.com
installing :code_highlighter to my.aws.amazon.com
installing :mail to my.aws.amazon.com
installing :mongodb to my.aws.amazon.com
installing :nginx to my.aws.amazon.com
installing :fire_net to my.aws.amazon.com
  installing fake gems
  installing gems
updating :fire_net on my.aws.amazon.com
  updating fake gems
  updating gems
starting :nginx on my.aws.amazon.com
deploying :fire_net to my.aws.amazon.com
  configuring
  symlinks
  copying assets
  restarting thin
stopping :thin on my.aws.amazon.com
starting :thin on my.aws.amazon.com
```

For more please see Rakefile and lib/services

[vos]: http://github.com/alexeypetrushin/vos
[vfs]: http://github.com/alexeypetrushin/vfs
[cluster_management]: https://github.com/alexeypetrushin/cluster_management