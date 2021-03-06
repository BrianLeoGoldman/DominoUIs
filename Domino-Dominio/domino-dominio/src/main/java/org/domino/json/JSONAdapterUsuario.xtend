package org.domino.json

import org.domino.dominio.Cliente
import org.domino.repo.RepoClientes
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.applicationContext.ApplicationContext

@Accessors
class JSONAdapterUsuario {
	
	String usuario
	String password
	String nombre
	String email
	String direccion

	def actualizar(Cliente cliente) {
		
		if (this.usuario !== null) {
			cliente.nick = this.usuario
		}
		if (this.password !== null) {
			cliente.password = this.password
		}
		if (this.nombre !== null) {
			cliente.nombre = this.nombre
		}
		if (this.email !== null) {
			cliente.email = this.email
		}
		if (this.direccion !== null) {
			cliente.direccion = this.direccion
		}
	}
	
	def toInstance() {
		var usuario1 = new Cliente(nombre, usuario, password, email, direccion)
		usuario1
	}
	
	def validarSesionDeUsuario() {
		val usuario = getClientes.findFirst[c | c.nick == usuario]
		
		if(usuario !== null && usuario.password.equals(password)){
		}else{
			throw new RuntimeException("La contraseña o usuario no coiniciden con nuestros registros, por favor, revise los datos")
		}
	}

	def getClientes() {
		val repoClientes = ApplicationContext.instance.getSingleton(typeof(Cliente)) as RepoClientes
		repoClientes.allInstances
	} 	
}