import Foundation

public class LibreLinkSwiftSDK {

    private var email: String = ""
    private var password: String = ""
    
    private var LIBRE_LINK_SERVER = "https://api-fr.libreview.io"
    private var jwtToken: String = ""
    private var connectionId: String = ""
    
    public func setCredendials(email: String, password: String){
        self.email = email
        self.password = password
    }
    
    public func login() {
        let loginResponse = sendRequest(method: "POST", path: "/llu/auth/login", body: ["email": self.email, "password": self.password])
        do {
            let answer = try JSONDecoder().decode(LoginRequestAnswer.self, from: loginResponse)
            self.jwtToken = answer.data.authTicket.token
        } catch {
            print("Error \(error)") // TODO: Handle redirects
        }
    }
    
    public func readRaw() -> ReadRawResponse {
        if(connectionId == ""){
            getConnectionId()
        }
        let readRawResponse = sendRequest(method: "GET", path: "/llu/connections/\(connectionId)/graph")
        
        let readRaw = try? JSONDecoder().decode(ReadRawResponse.self, from: readRawResponse)
        return readRaw!
    }
    
    public func read() -> GlucoseItem {
        let readRawResponse = readRaw()
        return readRawResponse.data.connection.glucoseMeasurement // TODO: Augment returned values
    }
    
    public func getActual() -> Int {
        let read = read()
        return read.Value
    }
    
    // Private functions
    
    private func sendRequest(method: String, path: String, body: [String: Any]? = nil) -> Data {
        let semaphore = DispatchSemaphore (value: 0)

        var result: Data = Data()
        var request = URLRequest(url: URL(string: "\(LIBRE_LINK_SERVER)\(path)")!,timeoutInterval: Double.infinity)
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("llu.android", forHTTPHeaderField: "product")
        request.addValue("4.2.1", forHTTPHeaderField: "version")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        if(self.jwtToken != ""){
            request.addValue("Bearer \(self.jwtToken)", forHTTPHeaderField: "authorization")
        }

        request.httpMethod = method
        
        if let bodyExist = body {
            let stringifiedBody = stringifyBody(body: bodyExist)
            let formattedBody = stringifiedBody.data(using: .utf8)
            request.httpBody = formattedBody
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            semaphore.signal()
            result = data
        }

        task.resume()
        semaphore.wait()
        return result
    }
    
    private func stringifyBody(body: [String: Any]) -> String {
        var stringifiedBody = ""
        
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            stringifiedBody = String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            print("Something went wrong when trying to stringify body: \(error)")
        }
        
        return stringifiedBody
    }
    
    private func getConnectionId() {
        let connectionsData = getConnections()
        connectionId = getConnection(connectionsData: connectionsData)
    }
    
    private func getConnections() -> GetConnectionsRequestAnswer{
        let connectionsResponse = self.sendRequest(method: "GET", path: "/llu/connections")
        let connections = try? JSONDecoder().decode(GetConnectionsRequestAnswer.self, from: connectionsResponse)
        return connections!
    }
    
    private func getConnection(connectionsData: GetConnectionsRequestAnswer) -> String {
        return connectionsData.data[0].patientId
    }
}
