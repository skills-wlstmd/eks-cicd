from flask import Flask, jsonify, render_template, request, abort
import os
import logging

app = Flask(__name__)

@app.route('/')
def image():
    image_files = "aws.png"
    image_files_exist = (os.path.isfile(f"static/{image_files}"))
    if image_files_exist:
        return render_template('index.html', image_file=(f"static/{image_files}"))
    else:
        return '', 404

@app.route('/green')
def source():
    return render_template('green.html')

@app.route('/health', methods=['GET'])
def get_health():
    try:
        ret = {'status': 'ok'}
        return jsonify(ret), 200
    except Exception as e:
        logging.error(e)
        abort(500)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
