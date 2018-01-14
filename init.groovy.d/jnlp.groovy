import hudson.model.*;
import jenkins.model.*;


println "--> setting agent port for jnlp"

Jenkins.instance.setSlaveAgentPort(50000)

Jenkins j = Jenkins.instance

if(!j.isQuietingDown()) {
    Set<String> agentProtocolsList = ['JNLP4-connect', 'Ping']
    if(!j.getAgentProtocols().equals(agentProtocolsList)) {
        j.setAgentProtocols(agentProtocolsList)
        println "--> agent Protocols have changed.  Setting: ${agentProtocolsList}"
        j.save()
    }
    else {
        println "--> nothing changed.  Agent Protocols already configured: ${j.getAgentProtocols()}"
    }
}
else {
    println '--> shutdown mode enabled.  Configure Agent Protocols SKIPPED.'
}
