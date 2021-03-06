/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * you may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.model.util.serializer.providers.bvalue;

import org.ballerinalang.model.types.BArrayType;
import org.ballerinalang.model.types.BTypes;
import org.ballerinalang.model.util.serializer.BPacket;
import org.ballerinalang.model.util.serializer.BValueDeserializer;
import org.ballerinalang.model.util.serializer.BValueSerializer;
import org.ballerinalang.model.util.serializer.JsonSerializerConst;
import org.ballerinalang.model.util.serializer.SerializationBValueProvider;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BRefType;
import org.ballerinalang.model.values.BRefValueArray;
import org.ballerinalang.model.values.BValue;

import java.util.HashSet;

/**
 * Class implements @{@link SerializationBValueProvider} to provide the mapping between {@link HashSet} and
 * {@link BValue} representation of it.
 *
 * @since 0.983.0
 */
public class HashSetBValueProvider implements SerializationBValueProvider<HashSet> {

    @Override
    public String typeName() {
        return getType().getName();
    }

    @Override
    public Class<?> getType() {
        return HashSet.class;
    }

    @Override
    public BPacket toBValue(HashSet set, BValueSerializer serializer) {
        BRefValueArray array = new BRefValueArray(new BArrayType(BTypes.typeAny));
        for (Object item : set) {
            array.append((BRefType) serializer.toBValue(item, null));
        }
        return BPacket
                .from(typeName(), array)
                .put(JsonSerializerConst.LENGTH_TAG, new BInteger(set.size()));
    }

    @SuppressWarnings("unchecked")
    @Override
    public HashSet toObject(BPacket packet, BValueDeserializer bValueDeserializer) {
        BInteger length = (BInteger) packet.get(JsonSerializerConst.LENGTH_TAG);
        BRefValueArray array = (BRefValueArray) packet.getValue();
        HashSet set = new HashSet((int) length.intValue());
        for (int i = 0; i < array.size(); i++) {
            set.add(bValueDeserializer.deserialize(array.get(i), null));
        }
        return set;
    }
}
