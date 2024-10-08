/*
 * Copyright Debezium Authors.
 *
 * Licensed under the Apache Software License version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 */
package io.debezium.example.server.mapper;

import jakarta.enterprise.context.Dependent;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.debezium.server.StreamNameMapper;

@Dependent
public class ConstantNameMapper implements StreamNameMapper {

    @ConfigProperty(name = "mapper.constant")
    String name;

    @Override
    public String map(String topic) {
        return name;
    }

}
