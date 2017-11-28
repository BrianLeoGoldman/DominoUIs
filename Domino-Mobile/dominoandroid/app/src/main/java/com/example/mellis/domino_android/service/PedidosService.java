package com.example.mellis.domino_android.service;

import com.example.mellis.domino_android.modelo.Pedido;

import java.util.List;

import retrofit.Call;
import retrofit.http.GET;
import retrofit.http.Path;

/**
 * Created by brian on 27/11/2017.
 */

public interface PedidosService {

    @GET("http://8.8.8.8:8080/pedidos")
    public Call<List<Pedido>> getAllPedidos();

    @GET("http://8.8.8.8:8080/pedidos/{id}")
    public Call<Pedido> getPedidoById(@Path("id") String id);

}
