from flask import jsonify

class Response:
    def __init__(self, code, message, data):
        self.code = code
        self.message = message
        self.data = data

    def json(self):
        return jsonify({'code': self.code, 'message': self.message, 'data': self.data})
