package org.domino.dominio

import java.time.LocalDateTime
import java.time.temporal.ChronoUnit
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.Entity
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.Observable

@Accessors
@Observable
class Pedido extends Entity {
	
	Cliente cliente
	LocalDateTime fecha
	String aclaracion
	List<Plato> platos  
	EstadoPedido estado
	FormaDeEnvio envio
	Integer numeroDePedido
	List<ServicioDeNotificacion> obs = newArrayList
	//public float montoTotal

	new(Cliente cliente, LocalDateTime fecha, String aclaracion, FormaDeEnvio envio) {
		this.cliente 	= cliente
		this.fecha		= fecha
		this.aclaracion	= aclaracion
		this.envio		= envio
		this.estado = new Preparando
		this.platos = newArrayList
	}
	
	new() {
		this.estado = new Preparando
		this.platos = newArrayList
	}
	
	def siguienteEstado(){
		this.estado = this.estado.siguienteEstado(this)
	}
	

	def anteriorEstado() {
		this.estado = this.estado.anteriorEstado(this)
	}
	
	def agregarPlato(Plato plato) {
		this.platos.add(plato)
	}
	@Dependencies("platos")
	def getMontoTotal() {
		platos.stream.mapToInt[p | p.montoTotal() as int].sum() + this.envio.recargo
	}
	
	def cancelar() {
		this.estado = new Cancelado
	}
	
	
	def tiempoDelPedido() {
		val diferenciaDeHoras= ChronoUnit.HOURS.between(fecha, LocalDateTime.now)
		val diferenciaDeMinutos= ChronoUnit.MINUTES.between(fecha, LocalDateTime.now)
		
		diferenciaDeHoras * 60 + diferenciaDeMinutos
	}
	
	
	def addObserver(ServicioDeNotificacion o){
		this.obs.add(o)
	}
	
	def notifyObservers(String mail, String msj) {
		obs.stream.forEach(s | s.sendMail(mail,"DominoPizza informa", msj))
	}
	
	def esAbierto() {
		!(this.estado.esCancelado || this.estado.esEntregado)
	}

}