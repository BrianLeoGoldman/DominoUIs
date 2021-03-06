package org.domino.model

import java.util.List
import org.domino.dominio.EstadoPedido
import org.domino.dominio.Pedido
import org.domino.dominio.Plato
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Dependencies
import org.uqbar.commons.model.annotations.TransactionalAndObservable
import org.uqbar.commons.model.utils.ObservableUtils

@Accessors
@TransactionalAndObservable
class PedidoApplicationModel {

	Pedido pedido
	Plato platoSeleccionado
	EstadoPedido estadoSeleccionado
	List<Plato> platosAAgregar

	new(Pedido pedido) {
		this.pedido = pedido
		if (!pedido.platos.nullOrEmpty) {
			this.platoSeleccionado = pedido.platos.get(0)
		}
		this.estadoSeleccionado = pedido.estado
		this.platosAAgregar = newArrayList
	}

	def getFechaTransformada() {
		var mes = pedido.fecha.month
		var dia = pedido.fecha.dayOfMonth
		var anio = pedido.fecha.year
		var res = dia.toString() + "/" + mes.toString() + "/" + anio.toString
		res
	}

	def getNombre() { 'Pedido #' + pedido.numeroDePedido }

	@Dependencies("platoSeleccionado")
	def getHayPlatoSeleccionado() {
		platoSeleccionado !== null
	}

	@Dependencies("platoSeleccionado")
	def setHayPlatoSeleccionado() {
		platoSeleccionado = null
	}

	def setEstadoSeleccionado(EstadoPedido estadoNuevo) {
		this.estadoSeleccionado = estadoNuevo
		pedido.estado = estadoNuevo
	}

	@Dependencies("pedido")
	def getHayPlatosEnPedido() {
		!this.pedido.platos.isEmpty
	}

	@Dependencies("pedido", "hayPlatoSeleccionado", "hayPlatosEnPedido")
	def getSePuedeSeleccionar() {
		this.pedido.esAbierto && this.hayPlatoSeleccionado && this.hayPlatosEnPedido
	}

	def actualizar() {
		ObservableUtils.firePropertyChanged(this, "pedido", this.pedido)
	}

	def confirmarAdicionDePlatos() {
		for (Plato p : platosAAgregar) {
			pedido.agregarPlato(p)
		}
		ObservableUtils.firePropertyChanged(pedido, "platos")
	}

	def cancelarAdicionDePlatos() {
		for (Plato p : platosAAgregar) {
			pedido.platos.remove(p)
		}
		platosAAgregar = newArrayList
		ObservableUtils.firePropertyChanged(pedido, "platos")
	}

}
