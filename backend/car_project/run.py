from app import create_app as main

app = main()

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')