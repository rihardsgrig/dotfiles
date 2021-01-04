### Todo

- [ ] script to setup git-sync for dir

  ```
    cd ~/aaa/dir
    git config --bool branch.master.sync true
    git config --bool branch.master.syncNewFiles true
  ```

- [ ] start auto-git-sync on boot

- [ ] notify if git-sync script fails

- [ ] repo script to parse file name, create directories based on file name (aaa.bbb.ccc.list), clone repos and if repo marked as sync repo setup git-sync `git@github.com:rihardsgrig/some-repo.git some-repo sync`. Don't store in `~/code/`.
