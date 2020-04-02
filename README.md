<pre>
   __                           _   _____                     _       _       
  / /  __ _ _ __ __ ___   _____| | /__   \___ _ __ ___  _ __ | | __ _| |_ ___ 
 / /  / _` | '__/ _` \ \ / / _ \ |   / /\/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
/ /__| (_| | | | (_| |\ V /  __/ |  / / |  __/ | | | | | |_) | | (_| | ||  __/
\____/\__,_|_|  \__,_| \_/ \___|_|  \/   \___|_| |_| |_| .__/|_|\__,_|\__\___|
                                                       |_|                    
</pre>
# Laravel Template

Laravel Template adalah **full stack project** untuk membangun aplikasi web berbasis laravel framework. Template memudahkan developer laravel untuk [devops](https://en.wikipedia.org/wiki/DevOps), otomasi CI/CD.
Fitur:
- aplikasi fullstack yang terdiri dari `nginx proxy`, `letsencrypt ssl`, `cron worker`, `php-fpm`, `postgresql`, `redis`.
- auto devops staging environment untuk review UAT
- auto devops production environment

## Installation

1. **Import project** https://gitlab.ipaymu.com/arakattack/laravel-template.git dengan metode Git repository URL ke `$repo_project_baru`. **New project → Import project → Git repository URL**

2. Di **GitLab repository → Settings → CI/CD → Runners page**, lihat ‘Specific Runners’, informasi url & token di bagian 'Set up a specific Runner manually' akan digunakan untuk register `gitlab-runner` di server sebagai berikut.
## Setup Docker Server
Project ini menggunakan 2 server: staging & production.
1. Install kedua server dengan OS ubuntu/debian.
2. Install gitlab-runner
```bash
$ curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
$ sudo apt-get install gitlab-runner
```
3. Daftarkan gitlab-runner
```bash
$ sudo gitlab-runner register
```
<pre>
name = "$nama_server"
url = "https://gitlab.ipaymu.com/"
token = "$token"
executor = "shell"
</pre>
4. Tambahkan user gitlab-runner ke sudoers
```bash
$ sudo echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
5. Install docker
```bash
$ sudo apt-get install docker.io
```
## Usage

1. Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) di komputer (jika belum), kemudian clone repository:

```bash
$ git clone https://gitlab.ipaymu.com/$repo_project_baru
$ cd $repo_project_baru
$ ./install.sh
```
2. Ganti password yang ditemukan di `.env.example`, `docker-compose.yml`
3. Edit `.gitlab-ci.yml` bagian `environment url`
## Development

### Branch
Branch digunakan untuk mengatur code WIP (Work In Progress) digunakan untuk mengisolasi kode dalam pengerjaan sebelum dikirim ke staging dan ke master (production).
#### Branch Developer
1. Setiap developer harus membuat branch sendiri
   
```bash
$ git branch nama-developer
$ git checkout nama-developer
```
...coding
#### Branch Issue/Hotfix
2. Untuk menghubungkan gitlab issue secara otomatis, buat branch untuk perbaikan tersebut dengan cara membuat branch sesuai id issue yang akan ditangani, contoh: `{id-issue}-nama-issue`

```bash
$ git branch 1-login-issue
$ git checkout 1-login-issue
```
...coding
#### Review /Merge Branch
3. Untuk mengirimkan code dari branch 1-login-issue ke branch staging, gunakan perintah sebagai berikut:
```bash
$ git add .
$ git commit -am "penjelasan detil"
$ git push origin 1-login-issue -o merge_request.create -o merge_request.target=staging
```
Pada langkah ini, issue otomatis akan diedit menjadi `WIP Nama Issue` dan akan diclose setelah merge.
4. Untuk menyetujui merge, gunakan perintah sebagai berikut:
```bash
$ git checkout staging
$ git merge 1-login-issue
```
>Pada langkah ini, code otomatis dikirimkan ke server staging. Bisa dicek live di https://staging.$domains
5. Untuk mengirimkan dari branch staging ke branch master, gunakan perintah sebagai berikut:
```bash
$ git checkout staging
$ git add .
$ git commit -am "penjelasan detil"
$ git push -o merge_request.create
```
6. Untuk menyetujui merge request dari branch staging ke branch master, dilakukan melalui gitlab karena deployment ke server production harus menggunakan tombol deploy manual di `pipeline`.
>Pada langkah ini, code otomatis dikirimkan ke server production setelah tombol deploy dijalankan. Bisa dicek live di https://$domains

><span style="color:red">Branch master tidak boleh dicheckout untuk diedit karena menggunakan mekanisme merge request.</span>
## Deployment
### Local
```bash
$ docker-compose up --build
```

### Docker Server
Pada saat developer `git push -o merge_request.create`, ada 2 aksi yang dilakukan sekaligus, yaitu: 
1. Code akan otomatis dikirim ke server staging
2. Merge request dari branch staging ke master

   - Merge request boleh dijalankan jika code dianggap sukses di server staging.
   - Ketika merge request dijalankan, deployment ke server production bisa dijalankan.
   - Jika terjadi kesalahan, bisa dirollback melalui tomboll rollback.

### Openshift
Sama dengan Docker Server

## License
[MIT](https://choosealicense.com/licenses/mit/)