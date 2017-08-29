package org.domino.dominio

import org.eclipse.xtend.lib.annotations.Accessors

import java.util.List

@Accessors
class Plato {
	
	Pizza pizza
	String tama�o
	List<Ingrediente> ingredientes
	
	new(Pizza pizza, String tama�o) {
		this.pizza 	= pizza
		this.tama�o		= tama�o
		this.ingredientes = newArrayList
	}
	
	def agregarIngredienteExtra(Ingrediente ingred){
		this.ingredientes.add(ingred)
	}
	
	def montoTotal() {
		1
	}
	
}