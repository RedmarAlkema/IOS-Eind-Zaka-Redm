import Foundation

class ExchangeRateService: ObservableObject {
    @Published var exchangeRates: [String: Double] = [:]
    private let apiKey = "af912e470c2e52ef8450f712" // ✅ Vergeet niet je eigen API-key hier in te vullen!

    func fetchExchangeRates(baseCurrency: String, completion: @escaping ([String: Double]) -> Void) {
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(baseCurrency)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.conversion_rates)
                }
            } catch {
                print("Error decoding exchange rates: \(error.localizedDescription)")
            }
        }.resume()
    }
}
	
struct ExchangeRateResponse: Codable {
    let conversion_rates: [String: Double]
}
