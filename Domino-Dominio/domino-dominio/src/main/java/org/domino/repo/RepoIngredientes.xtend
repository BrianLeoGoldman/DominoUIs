package org.domino.repo

import org.uqbar.commons.model.CollectionBasedRepo
import org.domino.dominio.Ingrediente
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.annotations.TransactionalAndObservable
import org.domino.dominio.Distribucion

@TransactionalAndObservable
class RepoIngredientes extends CollectionBasedRepo<Ingrediente>{
	
	def void create(String nombreI, int precioI, Distribucion distribucion){
		this.create(new Ingrediente(nombreI, precioI, distribucion))	
	}
	
	override protected getCriterio(Ingrediente example) {
		null
	}
	
	override createExample() {
		new Ingrediente
	}
	
	override getEntityType() {
		typeof(Ingrediente)
	}
	
	def getIngredientes(){
		allInstances
	}
}