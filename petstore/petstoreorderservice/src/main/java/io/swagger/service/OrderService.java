package io.swagger.service;

import com.chtrembl.petstore.order.model.Order;
import io.swagger.repository.OrderRepository;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    public void save(Order order) {
        orderRepository.save(order);
    }

    public Order get(String orderId) {
        return orderRepository.findById(orderId)
            .orElse(new Order());
    }
}
