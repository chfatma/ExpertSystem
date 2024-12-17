from flask import Flask, request, jsonify
from experta import *
from flask_cors import CORS

app = Flask(__name__)

CORS(app)
class OliveOilExpertSystem(KnowledgeEngine):
    @Rule(Fact(action='classify'), Fact(polyphenols=MATCH.W), Fact(acidity=MATCH.A), Fact(tocopherol=MATCH.T), Fact(fruit_median=MATCH.F), Fact(defaut_median=MATCH.D))
    def classify_oil(self, W, A, T, F, D):
        if W > 1200:
            self.declare(Fact(oil_type='Huile Médicament'))
        elif W > 500 and A < 0.2 and T > 300:
            self.declare(Fact(oil_type='Huile pour la Pharmacie'))
        elif 200 <= W <= 350:
            self.declare(Fact(oil_type='Huile destinée pour consommation de type Huile Douce'))
        elif 350 < W <= 500:
            self.declare(Fact(oil_type='Huile destinée pour consommation de type Huile Amère'))
        elif A < 1 and F > 0 and D == 0:
            self.declare(Fact(oil_type='Huile d\'Olive Extra'))
        elif A < 2 and F > 0 and 0 <= D <= 2.5:
            self.declare(Fact(oil_type='Huile d\'Olive Vierge'))
        elif A <= 3.3 and W < 200 and F == 0 and 2.5 <= D <= 6:
            self.declare(Fact(oil_type='Huile d\'Olive Courante'))
        else:
            self.declare(Fact(oil_type='Aucune correspondance trouvée'))

    @Rule(Fact(oil_type=MATCH.oil_type))
    def show_result(self, oil_type):
        self.result = oil_type  # Store the result in an instance variable

# Flask route to receive data and classify
@app.route('/classify_oil', methods=['POST'])
def classify_oil():
    data = request.json  # Receive JSON data from Postman

    # Extract data from the incoming request
    polyphenols = data.get('polyphenols')
    acidity = data.get('acidity')
    tocopherol = data.get('tocopherol')
    fruit_median = data.get('fruit_median')
    defaut_median = data.get('defaut_median')

    # Initialize the expert system
    engine = OliveOilExpertSystem()

    # Declare facts based on user input
    engine.reset()
    engine.declare(Fact(action='classify', polyphenols=polyphenols, acidity=acidity, tocopherol=tocopherol, fruit_median=fruit_median, defaut_median=defaut_median))

    # Run the engine
    engine.run()

    # Get the result from the engine
    oil_type = engine.result

    # Return the result in the response
    return jsonify({'oil_type': oil_type})

if __name__ == '__main__':
    app.run(debug=True)
