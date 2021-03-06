package org.domino.dominio

import org.domino.repo.RepoClientes
import org.domino.repo.RepoPedidos
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.applicationContext.ApplicationContext
import org.uqbar.commons.model.annotations.TransactionalAndObservable
import java.util.List

@Accessors
@TransactionalAndObservable 
class DominoPizza {
	
	Menu menu
	
	ServicioDeNotificacion servicio
	
	List <Distribucion> distribucion
	
			
	new(Menu menu, ServicioDeNotificacion servicio){
		this.menu = menu
		this.servicio = servicio
		ServicioDeNotificacion.config(this.servicio)
		this.distribucion = getDistribuciones()
		
	}
	
	def getDistribuciones(){
		Distribucion.values()
	}
	
	def agregarCliente(Cliente cliente) {
		if(!clientes.stream.anyMatch [c | c.email == cliente.email] &&
			!clientes.stream.anyMatch [c | c.nick == cliente.nick]) {
				repoClientes.create(cliente)
			}
		else {
			throw new RuntimeException("El nick "+cliente.nick+" que quiere usar ya se encuentra registrado. Por favor elija otro.")
		}
	}
	
	def realizarPedido(Pedido pedido) {
		repoPedidos.allInstances.stream.forEach[p | p.numeroDePedido = repoPedidos.allInstances.indexOf(p) + 1 ]
		repoPedidos.create(pedido)
		pedido.addObserver(servicio)
	}
	
	def getPedidos(){
		repoPedidos.allInstances
	}
	
	def getClientes() {
		repoClientes.allInstances
	}
	
	protected def RepoPedidos getRepoPedidos() {
		ApplicationContext.instance.getSingleton(typeof(Pedido)) as RepoPedidos
	}
	
	protected def RepoClientes getRepoClientes() {
		ApplicationContext.instance.getSingleton(typeof(Cliente)) as RepoClientes
	}
	
	
}