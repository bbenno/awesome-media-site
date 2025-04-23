{ pkgs, lib, config, inputs, ... }:
{
	dotenv.enable = true;

	languages.ruby.enable = true;
	languages.javascript.enable = true;

	packages = [
		pkgs.imagemagick
	];

  scripts = {
    build.exec = ''
      bundle exec middleman build -e production
    '';
    deploy.exec = ''
      rsync -amzuP build/ hhost:public_html/bbenno_m
    '';
  };
}
