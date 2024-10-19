import subprocess


def initialize_web():
    subprocess.call(['mv', 'web', 'web_backup'])
    subprocess.call(
        [
            "npx",
            "-y",
            "create-vue@latest",
            "web",
            "--typescript",
            "--router",
            "--pinia",
            "--vitest",
            "--playwright"
        ]
    )
    subprocess.call(["npm", "install", "--prefix", "./web"])
    subprocess.call('cp -r ./web_backup/* ./web_backup/.* web', shell=True)
    subprocess.call(['rm', '-r','web_backup'])

    print('Installing @biomejs/biome')
    subprocess.call(['npm', 'install', '--save-dev', '--save-exact', '--prefix', './web', '@biomejs/biome'])
    print('Installing oxlint')
    subprocess.call(['npm', 'install', '--save-dev', '--prefix', './web', '@biomejs/biome', 'oxlint'])


def initialize_backend():
    def create_api_project():
        subprocess.call(
            [
                "dotnet",
                "new",
                "webapi",
                "--use-controllers",
                "--name",
                "{{ cookiecutter.api_project }}",
                "--output",
                "./backend/{{ cookiecutter.api_project }}",
            ]
        )
        subprocess.call(
            [
                "dotnet",
                "sln",
                './backend/{{ cookiecutter.repo_name | title | replace("-", "") }}.sln',
                "add",
                './backend/{{ cookiecutter.api_project }}/{{ cookiecutter.api_project }}.csproj',
            ]
        )

    def create_solution():
        subprocess.call(
            [
                "dotnet",
                "new",
                "sln",
                "--name",
                '{{ cookiecutter.repo_name | title | replace("-", "") }}',
                "--output",
                "./backend",
            ]
        )

    create_solution()
    create_api_project()


def add_version_control():
    subprocess.call(["git", "init"])
    subprocess.call(['git', 'remote', 'add', 'origin', '{{ cookiecutter.remote_url }}'])
    subprocess.call(["git", "add", "*"])
    subprocess.call(["git", "commit", "-m", "Bootstrapped project from cookiecutter"])
    subprocess.call(["git", "push"])


if __name__ == "__main__":
    initialize_web()
    initialize_backend()
    add_version_control()
