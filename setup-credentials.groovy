import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;

def domain = Domain.global()
def store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def registryUsername = new File("/run/secrets/registry-username").text.trim()
def registryPassword = new File("/run/secrets/registry-password").text.trim()
def sshUsername = new File("/run/secrets/ssh-username").text.trim()

sshCredentials = new BasicSSHUserPrivateKey(
  CredentialsScope.GLOBAL,
  "ssh",
  sshUsername,
  new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
  "",
  "SSH Credentials"
)

registryCredentials = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  "nexus", "Docker Registry Credentials",
  nexusUsername,
  nexusPassword
)

store.addCredentials(domain, sshCredentials)
store.addCredentials(domain, registryCredentials)
