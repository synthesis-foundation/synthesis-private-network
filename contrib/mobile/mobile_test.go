package mobile

import "testing"

func TestStartSynthesis(t *testing.T) {
	spn := &Synthesis{}
	if err := spn.StartAutoconfigure(); err != nil {
		t.Fatalf("Failed to start Synthesis: %s", err)
	}
	t.Log("Address:", spn.GetAddressString())
	t.Log("Subnet:", spn.GetSubnetString())
	t.Log("Coords:", spn.GetCoordsString())
	if err := spn.Stop(); err != nil {
		t.Fatalf("Failed to stop Synthesis: %s", err)
	}
}
