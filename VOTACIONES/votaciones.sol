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

    function EsCandidato(string memory nombre ) public view returns(bool){
        uint length = candidatos.length;
        for(uint i = 0; i < length; i++){
            string memory candidato = candidatos[i];
            if ((keccak256(abi.encodePacked((candidato))) == keccak256(abi.encodePacked((nombre))))){
                return true;
            }
        }

        return false;
    }

    function Votar(string memory nombreCandidato) public{
        bool esCandidato = EsCandidato(nombreCandidato);
        if (esCandidato){
            
        }
    }
}