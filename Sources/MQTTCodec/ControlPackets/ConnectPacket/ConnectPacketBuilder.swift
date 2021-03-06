//
//  ConnectPacketBuilder.swift
//  MQTTCodec
//
//  Created by Bofei Zhu on 10/29/19.
//  Copyright © 2019 Bofei Zhu. All rights reserved.
//

import struct Foundation.Data

public final class ConnectPacketBuilder {

    private let clientId: String

    private var cleanStart: Bool = false

    private var keepAlive: UInt16 = 0

    private var willMessage: ConnectPacket.WillMessage?

    private var willQoS: QoS = .atMostOnce

    private var willRetain: Bool = false

    private var username: String?

    private var password: Data?

    public init(clientId: String) {
        self.clientId = clientId
    }

    public func cleanStart(_ cleanStart: Bool) -> ConnectPacketBuilder {
        self.cleanStart = cleanStart
        return self
    }

    public func keepAlive(_ keepAlive: UInt16) -> ConnectPacketBuilder {
        self.keepAlive = keepAlive
        return self
    }

    public func willMessage(
        _ willMessage: ConnectPacket.WillMessage?,
        willQoS: QoS = .atMostOnce,
        willRetain: Bool = false
    ) -> ConnectPacketBuilder {
        self.willMessage = willMessage
        self.willQoS = willQoS
        self.willRetain = willRetain
        return self
    }

    public func username(_ username: String?) -> ConnectPacketBuilder {
        self.username = username
        return self
    }

    public func password(_ password: Data?) -> ConnectPacketBuilder {
        self.password = password
        return self
    }

    /// Build CONNECT packet.
    ///
    /// - Returns: A CONNECT packet.
    public func build() -> ConnectPacket {
        let connectFlags = ConnectPacket.ConnectFlags(
            cleanStart: cleanStart,
            willFlag: willMessage != nil,
            willQoS: willQoS,
            willRetain: willRetain,
            passwordFlag: password != nil,
            userNameFlag: username != nil)

        let variableHeader = ConnectPacket.VariableHeader(
            connectFlags: connectFlags,
            keepAlive: keepAlive,
            properties: PropertyCollection())

        let payload = ConnectPacket.Payload(
            clientId: clientId,
            willMessage: willMessage,
            username: username,
            password: password)

        return ConnectPacket(variableHeader: variableHeader, payload: payload)
    }
}
