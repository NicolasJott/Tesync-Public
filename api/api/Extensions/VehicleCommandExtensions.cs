using api.Enums;

namespace api.Extensions;

public static class VehicleCommandExtensions
{
    public static string ToApiPath(this VehicleCommand command)
    {
        return command switch
        {
            VehicleCommand.FlashLights => "flash_lights",
            VehicleCommand.HonkHorn => "honk_horn",
            VehicleCommand.DoorLock => "door_lock",
            VehicleCommand.DoorUnlock => "door_unlock",
            VehicleCommand.ActuateTrunk => "actuate_trunk",
            VehicleCommand.AutoConditioningStart => "auto_conditioning_start",
            VehicleCommand.AutoConditioningStop => "auto_conditioning_stop",
            VehicleCommand.CancelSoftwareUpdate => "cancel_software_update",
            VehicleCommand.ChargeMaxRange => "charge_max_range",
            VehicleCommand.ChargePortDoorOpen => "charge_port_door_open",
            VehicleCommand.ChargePortDoorClosed => "charge_port_door_closed",
            VehicleCommand.AddPreconditionSchedule => "add_precondition_schedule",
            VehicleCommand.RemovePreconditionSchedule => "remove_precondition_schedule",
            VehicleCommand.SetTemps => "set_temps",
            VehicleCommand.ChargeStart => "charge_start",
            VehicleCommand.ChargeStop => "charge_stop",
            VehicleCommand.RemoteSeatHeaterRequest => "remote_seat_heater_request",
            _ => throw new ArgumentOutOfRangeException(nameof(command), command, null)
        };
    }
}