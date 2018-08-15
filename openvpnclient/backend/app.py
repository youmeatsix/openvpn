import os
from flask import Flask, request, redirect, url_for, flash, render_template
from werkzeug.utils import secure_filename

application = Flask(__name__, template_folder=os.path.join(os.path.dirname(os.path.dirname(__file__)), 'frontend'))
application.config['UPLOAD_FOLDER'] = '/share/openvpnclient/'

_FILES = [
    'ca.crt',
    'client.crt',
    'client.key',
    'ta.key'
]


@application.route('/', methods=['GET', 'POST'])
def root():
    return render_template('index.html')


@application.route('/ca_crt/', methods=['POST'])
@application.route('/client_cert/', methods=['POST'])
@application.route('/client_key/', methods=['POST'])
@application.route('/ta_key/', methods=['POST'])
def upload():
    if request.method == 'POST':
        # check if the post request has the file part
        files = request.files.getlist('file')
        # if user does not select file, browser also
        # submit a empty part without filename
        for file in files:
            if file.filename == '':
                flash('No selected file')
                return redirect(request.url)
            if file:

                filename = os.path.join(application.config['UPLOAD_FOLDER'], secure_filename(file.filename))
                print("Save file {file} into {path}".format(file=file, path=filename))
                file.save(filename)
        return redirect(url_for('root'))



if __name__ == '__main__':
    application.run()

