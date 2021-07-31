from flask import Flask, jsonify, json, render_template
import logging
app = Flask(__name__)

@app.route('/')
def index():
	return render_template('index.html')

@app.route('/user-auth/')
def user_auth():
	return jsonify(json.load(open("database/user_auth/profile.json")))

@app.route('/medical-record/')
def medical_record():
	return jsonify(json.load(open("database/medical_record/diagnose_log.json")))

@app.route('/health-info/')
def health_info():
	return jsonify(json.load(open("database/health_info/disease_generic.json")))

app.run(debug=True)