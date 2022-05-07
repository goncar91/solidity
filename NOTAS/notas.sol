// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.4 <= 0.8.13;
pragma experimental ABIEncoderV2;
 
//    ALUMNO  |   ID   |  NOTA 
//    Marcos  | 77755N |    5
//    Joan    | 12345X |    9
//    Maria   | 02468T |    2
//    Marta   | 13579U |    3
//    Alba    | 98765Z |    5

contract notas{
    
    // Direccion del profesor
    address public profesor;

    // Constructor
    constructor () public{
        profesor = msg.sender;
    }

    // Mapping para relacionar el hash de la entidad del alumno con su nota del examen
    mapping (bytes32 => uint) Notas;

    // Array de alumnos que piden la revision del examen
    string[] revisiones;

    //Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);

    // Funcion para evaluar a los alumnos
    function Evaluar(string memory _idAlumno, uint nota) public UnicamenteProfesor(msg.sender) {
        // Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Relacion entre el hash de la identificacion y la nota
        Notas[hash_idAlumno] = nota;
        // Emitimos el evento de la evaluacion
        emit alumno_evaluado(hash_idAlumno);
    }

    modifier UnicamenteProfesor(address _direccion){
        // Requiere que la direccion del parámetro sea igual al owner del contrato que es el profesor
        require(_direccion == profesor, "No tienes permiso para ejecutar esta funcion");
        _;        
    }

    // Ver las notas de un alumno
    function VerNotas(string memory _idAlumno) public view returns(uint){
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Nota asociada al hash del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        return nota_alumno;
    }

    //Función para pedir revision del examen
    function Revision(string memory _idAlumno) public{
        // Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        emit evento_revision(_idAlumno);
    }

    function VerRevisiones() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        return revisiones;
    }

}