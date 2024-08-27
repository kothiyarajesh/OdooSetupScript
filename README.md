
# [Odoo](https://www.odoo.com "Odoo's Homepage") Setup Script

**Odoo Setup Shell Script**

This shell script is specially designed to set up multiple Odoo versions simultaneously on a local machine. It's an ideal tool for developers who need to install and manage multiple Odoo versions, such as 15, 16, and 17, in one go on a fresh PC. If you're looking for a complete Odoo server setup, you may want to check out this comprehensive server installation script [here](https://github.com/Yenthe666/InstallScript).

### Features

- **Multi-Version Installation**: Easily install and manage multiple Odoo versions (15, 16, and 17) on your local machine.
- **Isolated Environments**: Each Odoo version is installed in a separate Conda environment, ensuring a clean and isolated setup.
- **Flexible Configuration**: Customize the installation process by enabling or disabling Python, PostgreSQL, and Anaconda installations.

### Configuration

You can customize the following parameters before running the script:

- **`PYTHON_INSTALL`**: Set to `True` to install Python 3 and related packages.
- **`POSTGRESQL_INSTALL`**: Set to `True` to install PostgreSQL.
- **`ANACONDA_INSTALL`**: Set to `True` to install Anaconda.

The script will automatically create the necessary directories at `WORKSPACE_DIR`, and install the `requirements.txt` dependencies within the respective Conda environments.

### Usage

To activate the Conda environments for different Odoo versions, use the following commands:

```bash
conda activate env_odoo15
conda activate env_odoo16
conda activate env_odoo17
```

To deactivate an active environment, use:

```bash
conda deactivate
```

### Running the Script

To execute the script, simply run:

```bash
. odoo_setup.sh
```

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
