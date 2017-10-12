package com.domino.xtrest

import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException
import java.time.LocalDateTime
import org.domino.dominio.DominoPizza
import org.uqbar.xtrest.json.JSONUtils
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Body
import org.domino.dominio.Pedido
import org.domino.json.JSONAdapterEstado
import org.domino.json.JSONAdapterPedido
import java.time.LocalDateTime
import org.domino.json.JSONViewerPedido
import org.domino.json.JSONViewerUsuario
import org.domino.repo.RepoPedidos
import org.uqbar.commons.applicationContext.ApplicationContext
import org.uqbar.commons.model.exceptions.UserException
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils

@Controller
class DominoRestAPI {
	
	extension JSONUtils = new JSONUtils
	
	DominoPizza dominoPizza
	
	new(DominoPizza pizza) {
		this.dominoPizza = pizza
	}
	
	@Get("/promos")
	def getPromos() {
		response.contentType = ContentType.APPLICATION_JSON
		return ok(this.dominoPizza.menu.promos.toJson)
	}
	
	@Get("/tamanios")
	def getTamaniosAPI() {
		response.contentType = ContentType.APPLICATION_JSON
		return ok(this.dominoPizza.menu.tamanios.toJson)
	}
	
	@Get("/ingredientes")
	def getIngredientes() {
		response.contentType = ContentType.APPLICATION_JSON
		return ok(this.dominoPizza.menu.ingredientes.toJson)
	}

	@Post("/pedidos")
	def createPedido(@Body String body) {
		response.contentType = ContentType.APPLICATION_JSON
		try {
			val pedidoJSON = body.fromJson(JSONAdapterPedido)
			try {

				val platos = pedidoJSON.platos
				val cliente = this.dominoPizza.clientes.findFirst[c|c.id == pedidoJSON.id_usuario]
				val envio = pedidoJSON.entrega.toInstance
				val pedido = new Pedido(cliente, LocalDateTime.now, pedidoJSON.aclaraciones, envio);
				platos.forEach[p|pedido.agregarPlato(p)]
				this.dominoPizza.realizarPedido(pedido)
				return ok()
			} catch (UserException exception) {
				return badRequest(getErrorJson(exception.message))
			}
		} catch (UnrecognizedPropertyException exception) {
			return badRequest(getErrorJson("El body debe ser un Pedido"))
		}
	}

	@Get("/pedidos/:id")
	def getPedidoById() {
		response.contentType = ContentType.APPLICATION_JSON
		val res = new JSONViewerPedido(this.dominoPizza.pedidos.findFirst[p | p.id == Integer.valueOf(id)])
		return ok(res.toJson)
	}

	@Get("/pedidos/estado")
	def getPedidoByState(String estado) {
		response.contentType = ContentType.APPLICATION_JSON
		val matchedPedidos = this.dominoPizza.pedidos.filter [ p |
			p.estado.nombre.replaceAll("[^A-Za-z]+", "").toLowerCase == estado
		].toList
		val res = matchedPedidos.map[p|new JSONViewerPedido(p)].toList
		return ok(res.toJson)
	}

	@Get("/pedidos/user_id")
	def getPedidoByUserId(String user_id) {
		response.contentType = ContentType.APPLICATION_JSON
		val matchedPedidos = this.dominoPizza.pedidos.filter [ p |
			p.cliente.id == Integer.valueOf(user_id)
		].toList
		val res = matchedPedidos.map[p|new JSONViewerPedido(p)].toList
		return ok(res.toJson)
	}

	@Post("/pedidos/:id/estado")
	def changePedidoState(@Body String body) {
		response.contentType = ContentType.APPLICATION_JSON
		try {
			val estadoJSON = body.fromJson(JSONAdapterEstado)
			try {
				val pedido = this.dominoPizza.pedidos.findFirst[p | p.id == Integer.valueOf(id)]
				val estado = estadoJSON.toInstance
				pedido.estado = estado
				return ok()
			} catch (UserException exception) {
				return badRequest(getErrorJson(exception.message))
			}
		} catch (UnrecognizedPropertyException exception) {
			return badRequest(getErrorJson("El body debe ser un Pedido"))
		}

	}
    
    @Get("/usuarios/:id")
    def getUsuarioById() {
    	response.contentType = ContentType.APPLICATION_JSON
    	val res = new JSONViewerUsuario(this.dominoPizza.repoClientes.findFirst[c | c.id == Integer.valueOf(id)])
    	return ok(res.toJson)
    }
    
    @Put("/usuarios/:id")
    def editUsuario(@Body String body) {
        response.contentType = ContentType.APPLICATION_JSON
        try {
            var userJSON = body.fromJson(JSONAdapterUsuario)
        	var usuario = this.dominoPizza.repoClientes.findFirst[c | c.id == Integer.valueOf(id)]
            try {
                userJSON.actualizar(usuario)
                return ok()
            } catch (UserException exception) {
                return badRequest(getErrorJson(exception.message))
            }
        } catch (UnrecognizedPropertyException exception) {
            return badRequest(getErrorJson("El body debe contener campos validos para un Usuario"))
        }
    }
    
    private def getErrorJson(String message) {
        '{ "error": "' + message + '" }'
    }
	
}
