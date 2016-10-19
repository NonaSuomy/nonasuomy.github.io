---
layout: post
title: Local Jeykll Github Pages And Live Code Samples
---

# Resources #

https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/#keeping-your-site-up-to-date-with-the-github-pages-gem

# Arch Linux Install#

## Install Ruby And Gems ##

Open Terminal.

Check whether you have Ruby 2.0.0 or higher installed:

```
ruby --version
ruby 2.X.X
```

If you don't have Ruby installed, install Ruby 2.0.0 or higher.

```
sudo pacman -S ruby
```

Install Bundler:

```
gem install bundler
Fetching: bundler-1.13.3.gem (100%)
WARNING:  You don't have /home/username/.gem/ruby/2.3.0/bin in your PATH,
	  gem executables will not run.
Successfully installed bundler-1.13.3
Parsing documentation for bundler-1.13.3
Installing ri documentation for bundler-1.13.3
Done installing documentation for bundler after 8 seconds
1 gem installed
```

*Note:* If you see this message:
WARNING:  You don't have /home/username/.gem/ruby/2.3.0/bin in your PATH, gem executables will not run.

```
export PATH=$PATH:/home/username/.gem/ruby/2.3.0/bin
```

### Installs the Bundler gem ###

If you already have a local repository for your Jekyll site, skip to Step 2.

Step 1: Create a local repository for your Jekyll site

If you haven't already downloaded Git, install it. For more information, see "Set up Git."
Open Terminal.

```
sudo pacman -S git
```

On your local computer, initialize a new Git repository for your Jekyll site:

```
git init my-jekyll-site-project-name
```

Initialized empty Git repository in /home/username/my-jekyll-site-project-name/.git/

Creates a new file directory on your local computer, initialized as a Git repository

Change directories to the new repository you created:

```
cd my-jekyll-site-project-name
```

If your new local repository is for a Project pages site, create a new gh-pages branch:

**Note:** *You can skip this step if you would rather use the master branch for your Project Page. If you haven't checked out any branches, once you make a commit in your local repository, your change will appear on the master branch by default.*

```
git checkout -b gh-pages
```

Switched to a new branch 'gh-pages'

Creates a new branch called 'gh-pages', and checks it out

Tip: To learn more about creating a User, Organization or Project Page and which branch to use, see "User, Organization, and Project Pages." To learn more about how to build your site's source files from a /docs folder on the master branch, see "Configuring a publishing source for GitHub Pages."

Step 2: Install Jekyll using Bundler

To track your site's dependencies, Ruby will use the contents of your Gemfile to build your Jekyll site.

Check to see if you have a Gemfile in your local Jekyll site repository:

```
ls
Gemfile
```

If you have a Gemfile, skip to step 4. If you don't have a Gemfile, skip to step 2.

If you don't have a Gemfile, open your favorite text editor, such as Atom, and add these lines to a new file:

```
sudo pacman -S atom
atom
```

Edit Gemfile

```
nano Gemfile
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```

Name the file Gemfile and save it to the root directory of your local Jekyll site repository. Skip to step 5 to install Jekyll.

If you already have a Gemfile, open your favorite text editor, such as Atom, and add these lines to your Gemfile:

```
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```

Install Jekyll and other dependencies from the GitHub Pages gem:

```
bundle install

Fetching gem metadata from https://rubygems.org/............
Fetching version metadata from https://rubygems.org/...
Fetching dependency metadata from https://rubygems.org/..
Resolving dependencies...
```

Step 3 (optional): Generate Jekyll site files

To build your Jekyll site locally, preview your site changes, and troubleshoot build errors, you must have Jekyll site files on your local computer. You may already have Jekyll site files on your local computer if you cloned a Jekyll site repository. If you don't have a Jekyll site downloaded, you can generate Jekyll site files for a basic Jekyll template site in your local repository.

If you want to use an existing Jekyll site repository on GitHub as the starting template for your Jekyll site, fork and clone the Jekyll site repository on GitHub to your local computer. For more information, see "Fork a repo."

**Note:** *As of Jekyll 3.2, the default Jekyll site contains a Gemfile that locks Jekyll to the Gem version you build it with. To instead lock it to the version used by GitHub Pages, you'll uncomment the gem "github-pages", group :jekyll_plugins line in the steps below.*

If you don't already have a Jekyll site on your local computer, create a Jekyll template site:

```
bundle exec jekyll new . --force
```

New jekyll site installed in /home/username/my-jekyll-site-project-name.

Edit your Gemfile and remove the following line:

"jekyll", "3.2.1"
Uncomment the following line by removing the #:

```
gem "github-pages", group :jekyll_plugins
```

To edit the Jekyll template site, open your new Jekyll site files in a text editor. Make your changes and save them in the text editor. You can preview these changes locally without committing your changes using Git.

If you want to publish your changes on your site, you must commit your changes and push them to GitHub using Git. For more information on this workflow, see "Good Resources for Learning Git and GitHub" or see this Git cheat sheet.

Step 4: Build your local Jekyll site

Navigate into the root directory of your local Jekyll site repository.

Run your Jekyll site locally:

```
bundle exec jekyll serve
Configuration file: /home/username/my-jekyll-site-project-name/_config.yml
           Source: /home/username/my-jekyll-site-project-name/my-site
      Destination: /home/username/my-jekyll-site-project-name/_site
Incremental build: disabled. Enable with --incremental
     Generating...
                   done in 0.309 seconds.
Auto-regeneration: enabled for '/home/username/my-jekyll-site-project-name'
Configuration file: /home/username/my-jekyll-site-project-name/_config.yml
   Server address: http://127.0.0.1:4000/
 Server running... press ctrl-c to stop.
Preview your local Jekyll site in your web browser at http://localhost:4000.
```

Open web browser of choice and go to http://localhoost:4000.

You should see the jekyll website.

*Note:* jekyll 3.2.1 | Error:  Could not find a JavaScript runtime
Could not find a JavaScript runtime. (ExecJS::RuntimeUnavailable)Permalink

This error can occur during the installation of jekyll-coffeescript when you don’t have a proper JavaScript runtime. To solve this, either install execjs and therubyracer gems, or install nodejs. Check out issue #2327 for more info.

```
sudo pacman -S nodejs npm
```

or

```
gem install therubyracer
```

Then run "bundle exec jekyll serve" again.

Keeping your site up to date with the GitHub Pages gem

Jekyll is an active open source project and is updated frequently. As the GitHub Pages server is updated, the software on your computer may become out of date, resulting in your site appearing different locally from how it looks when published on GitHub.

Open Terminal.

Run this update command:

```
bundle update
```

If you followed our setup recommendations and installed Bundler, run bundle update github-pages or simply bundle update and all your gems will update to the latest versions.

If you don't have Bundler installed, run gem update github-pages
Next steps: Configuring Jekyll

To configure your pages site further, see "Configuring Jekyll." To set up a project pages site, see Jekyll's official documentation on project pages URLs.

Further Reading

"Troubleshooting GitHub Pages Builds"
"Using Jekyll as a static site generator with GitHub Pages"
Jekyll's official GitHub Pages documentation
Jekyll commands


# Add Live Github Code Samples #

https://github.com/bwillis/jekyll-github-sample/blob/master/README.md

Install jekyll github sample gem

```
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
gem 'rouge'
gem 'jekyll_github_sample'
```

Add gem jekyll github sample to the Gemfile

```
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
gem 'rouge'
gem 'jekyll_github_sample'
```

Add gem jekyll github sample to the config.yml

```
nano _config.yml
# Use the following plug-ins
gems:
  - jekyll-sitemap # Create a sitemap using the official Jekyll sitemap gem
  - jekyll-feed # Create an Atom feed using the official Jekyll feed gem
  - rouge # Highlight Code Syntax.
  - jekyll_github_sample # Add live github code samples.
```

### github_sample Usage ###


{% raw %}
{% github_sample URL_WITH_USERNAME_REPO_AND_FILE <START_LINE_NUMBER> <END_LINE_NUMBER> %}
{% endraw %}

```
URL_WITH_USERNAME_REPO_AND_FILE - The relative path to the Github repo file, prefer a file with the commitish in it so it won't change when recompiling occurs. A url to this README would be: bwillis/jekyll-github-sample/blob/a3bc9e82412d364aa76e9308ab53ff2bddaa2faf/README.md

START_LINE_NUMBER - (optional) number that is the first line to include (0 based)

END_LINE_NUMBER - (optional) number that is the last line to include, if excluded will read to end of file github_sample_ref Usage
```

{% raw %}
{% github_sample_ref URL_WITH_USERNAME_REPO_AND_FILE %}
{% endraw %}

```
URL_WITH_USERNAME_REPO_AND_FILE - The relative path to the Github repo file, prefer a file with the commit in it so it won't change when recompiling occurs. A url to this README would be: bwillis/jekyll-github-sample/blob/a3bc9e82412d364aa76e9308ab53ff2bddaa2faf/README.md Example Usage
```

This is how you would display, reference and highlight code in your Jekyll post.

Sample URL:

https://github.com/NonaSuomy/nonasuomy.github.io/blob/d2d123c640e2cb18e57d13bb7631a331c1018d8b/README.md

{% raw %}
{% github_sample_ref /NonaSuomy/nonasuomy.github.io/blob/d2d123c640e2cb18e57d13bb7631a331c1018d8b/README.md %}
{% highlight ruby %}
{% github_sample /NonaSuomy/nonasuomy.github.io/blob/d2d123c640e2cb18e57d13bb7631a331c1018d8b/README.md 0 5 %}
{% endhighlight %}
{% endraw %}

### Static GIST pages ###

{% raw %}
{% 0895a6778d7906ce79cfd64f93e4dae1 %}
{% endraw %}

{% 0895a6778d7906ce79cfd64f93e4dae1 %}
