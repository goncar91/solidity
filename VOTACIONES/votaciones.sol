// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.4 <= 0.8.13;
pragma experimental ABIEncoderV2;

//  CANDIDATO |   EDAD  |     ID 
//    Toni    |    20   |   23432DX
//   Alberto  |    23   |   123432G
//    Joan    |    21   |   325443H
//    Javier  |    19   |   342324M
 


contract votacion{

    // Direccion del propietario del contrato
    address owner;

    // Constructor
    constructor () {
        owner = msg.sender;
    }

    // Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string=>bytes32) idCandidato;

    // Relacion entre el candidato y el número de votos
    mapping (string => uint) votosCandidato;

    // Lista de candidatos
    string[] candidatos;

    // Lista de los votantes
    bytes32[] votantes;

    modifier UnicamenteOwner(address _direccion){
        // Requiere que la direccion del parámetro sea igual al owner del contrato que es el profesor
        require(_direccion == owner, "No tienes permiso para ejecutar esta funcion");
        _;        
    }

    //  Cualquier persona pueda usar esta funcion para presentarse a las elecciones
    function Representar(string memory _nombrePersona, uint _edadPersona, string memory _idPersona) public{
        
        bool existeCandidato = EsCandidato(_nombrePersona);
        require(existeCandidato==false, "Ya existe el candidato");
        
        // Hash de los datos del candidato
        bytes32 hashCandidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));

        // Almacenar el hash de los datos del candidato ligados a su nombre
        idCandidato[_nombrePersona] = hashCandidato;

        // Almacenamos el nombre del candidato
        candidatos.push(_nombrePersona);
    }

    function VerCandidatos() public view returns(string[] memory){
        return candidatos;
    }

    function EsCandidato(string memory nombre ) internal view returns(bool){
        uint length = candidatos.length;
        for(uint i = 0; i < length; i++){
            string memory candidato = candidatos[i];
            if ((keccak256(abi.encodePacked((candidato))) == keccak256(abi.encodePacked((nombre))))){
                return true;
            }
        }

        return false;
    }

    function VotadoPreviamente(address votante) internal view returns(bool){
        // Calculamos el hash de la persona que ejecuta la funcion
        bytes32 hashVotante = keccak256(abi.encodePacked(votante));
        // Comprobamos que el votante no haya votado ya
        for(uint i = 0; i < votantes.length; i++){
            //require(votantes[i]!=hashVotante, "Ya has votado previamente");
            if (votantes[i]==hashVotante){
                return true;
            }
        }
        return false;
    }

    function Votar(string memory nombreCandidato) public{
        
        bool votadoPreviamente = VotadoPreviamente(msg.sender);
        require(votadoPreviamente==false, "Ya has votado previamente");

        
        bool existeCandidato = EsCandidato(nombreCandidato);
        require(existeCandidato==true, "No existe el candidado elegido");
        
        bytes32 hashVotante = keccak256(abi.encodePacked(msg.sender));
        votantes.push(hashVotante);
        // Añadimos un voto al candidato
        votosCandidato[nombreCandidato]++;
            
    }

    function NumeroVotosCandidato(string memory nombreCandidato) public view returns(uint){
        bool existeCandidato = EsCandidato(nombreCandidato);
        require(existeCandidato==true, "No existe el candidado elegido");
        return votosCandidato[nombreCandidato];
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function VerResultados() public view returns (string memory){
        string memory resultados = "";

        for (uint i = 0; i < candidatos.length; i++){
            string memory candidato = candidatos[i];
            string memory numeroVotos = uint2str(votosCandidato[candidato]);

            resultados = string(abi.encodePacked(resultados, "(", candidato, ", ", numeroVotos, ")"));
        }

        return resultados;
    }

    function Ganador() public view returns (string memory){
        string memory ganador = candidatos[0];

        for (uint i = 1; i < candidatos.length; i++){
            if (votosCandidato[ganador]<votosCandidato[candidatos[i]]){
                ganador = candidatos[i];
            }
        }


        return ganador;

    }
    
}