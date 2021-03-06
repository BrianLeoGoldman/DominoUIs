package org.domino.json

import java.util.List
import org.uqbar.commons.applicationContext.ApplicationContext
import org.domino.repo.RepoPizzas
import org.domino.dominio.Pizza
import org.domino.dominio.Tamanio
import org.domino.repo.RepoTamanios
import org.domino.dominio.Plato
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class JSONAdapterPlato {
	
	int id_promo
	String id_tamanio
	List<JSONAdapterIngrediente> extras
	
	def crearPlato() {
		val promo = promos.findFirst[p| p.id == this.id_promo]
		val tamanio = tamanios.findFirst[t | t.nombre == this.id_tamanio]
		
		var plato = new Plato()
		plato.tamanio = tamanio
		plato.pizza = promo
		ponerIngredientes(plato)
		plato
	}
	
	def ponerIngredientes(Plato plato) {
		extras.forEach[e | plato.agregarIngrediente(e.toInstance)]
	}
	
	def getTamanios() {
		val repoTamanio = ApplicationContext.instance.getSingleton(typeof(Tamanio)) as RepoTamanios
		repoTamanio.allInstances
	}
	
	def getPromos() {
		val repoPromos = ApplicationContext.instance.getSingleton(typeof(Pizza)) as RepoPizzas
		repoPromos.allInstances
	}
	
}