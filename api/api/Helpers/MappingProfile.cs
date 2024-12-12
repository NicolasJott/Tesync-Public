using api.DTOs.TeslaAccounts;
using AutoMapper;
using api.Models;
using api.DTOs.Users;

namespace api.Helpers;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        // Define the mapping between User and UserDto
        CreateMap<User, UserDto>();
        
        CreateMap<TeslaAccount, TeslaAccountDto>();
        
        CreateMap<UpdateUserDto, User>()
            .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
    }
}