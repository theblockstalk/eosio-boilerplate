#include <eosio.bios/eosio.bios.hpp>

namespace eosiobios {


void bios::newaccount( name creator, name name, ignore<authority> owner, ignore<authority> active) {
   // require_auth(creator); // this is done implicity in apply_eosio_newaccount()...

   // This action can only be called by inline action "newaccount2"
   check(eosio::get_sender() == get_self(), "call newaccount2 to create a new account");
}

void bios::newperson( name creator, name name, uint32_t account_type, authority owner, authority active) {
   bios::newaccount_action(get_self(), {creator, "active"_n})
      .send(creator, name, owner, active);
}

void bios::newentity( name creator, name name, uint32_t account_type, authority owner, authority active) {
   check(owner.keys.size() == 0, "Only humans can have private keys, use account links instead");
   check(active.keys.size() == 0, "Only humans can have private keys, use account links instead");
   bios::newaccount_action(get_self(), {creator, "active"_n})
      .send(creator, name, owner, active);
}

/*struct authority {
   uint32_t                          threshold = 0;
   vector<key_weight>                keys;
   vector<permission_level_weight>   accounts;
   vector<wait_weight>               waits;
}
authority{
   .threshold = 1,
   .keys      = {key_weight{.key = owner_key, .weight = 1}},
   .accounts  = {},
   .waits     = {}}
*/
                          
void bios::setabi( name account, const std::vector<char>& abi ) {
   abi_hash_table table(get_self(), get_self().value);
   auto itr = table.find( account.value );
   if( itr == table.end() ) {
      table.emplace( account, [&]( auto& row ) {
         row.owner = account;
         row.hash  = eosio::sha256(const_cast<char*>(abi.data()), abi.size());
      });
   } else {
      table.modify( itr, eosio::same_payer, [&]( auto& row ) {
         row.hash = eosio::sha256(const_cast<char*>(abi.data()), abi.size());
      });
   }
}

void bios::onerror( ignore<uint128_t>, ignore<std::vector<char>> ) {
   check( false, "the onerror action cannot be called directly" );
}

void bios::setpriv( name account, uint8_t is_priv ) {
   require_auth( get_self() );
   set_privileged( account, is_priv );
}

void bios::setalimits( name account, int64_t ram_bytes, int64_t net_weight, int64_t cpu_weight ) {
   require_auth( get_self() );
   set_resource_limits( account, ram_bytes, net_weight, cpu_weight );
}

void bios::setprods( const std::vector<eosio::producer_authority>& schedule ) {
   require_auth( get_self() );
   set_proposed_producers( schedule );
}

void bios::setparams( const eosio::blockchain_parameters& params ) {
   require_auth( get_self() );
   set_blockchain_parameters( params );
}

void bios::reqauth( name from ) {
   require_auth( from );
}

void bios::activate( const eosio::checksum256& feature_digest ) {
   require_auth( get_self() );
   preactivate_feature( feature_digest );
}

void bios::reqactivated( const eosio::checksum256& feature_digest ) {
   check( is_feature_activated( feature_digest ), "protocol feature is not activated" );
}

}
