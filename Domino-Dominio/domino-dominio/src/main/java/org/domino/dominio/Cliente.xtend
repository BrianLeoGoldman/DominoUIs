package org.domino.dominio

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.Entity

@Observable
@Accessors
class Cliente extends Entity{
	
	public String nombre
	public String nick
	public String password
	public String email
	public String direccion
	
	new(String nombre, String nick, String password, String email, String direccion) {
		this.nombre 	= nombre
		this.nick		= nick
		this.password	= password
		this.email		= email
		this.direccion	= direccion
	}
	
	new() {
	
	}
	
}