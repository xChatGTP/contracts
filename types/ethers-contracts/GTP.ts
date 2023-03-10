/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "./common";

export interface GTPInterface extends utils.Interface {
  functions: {
    "MSG_SENDER_KEY()": FunctionFragment;
    "PERCENTAGE_BASE()": FunctionFragment;
    "POSTPROCESS_SIG()": FunctionFragment;
    "batchExec(address[],bytes32[],bytes[])": FunctionFragment;
    "cache(bytes32)": FunctionFragment;
    "execs(address[],bytes32[],bytes[])": FunctionFragment;
    "execute(bytes32,string,string,bytes)": FunctionFragment;
    "executeWithToken(bytes32,string,string,bytes,string,uint256)": FunctionFragment;
    "gasReceiver()": FunctionFragment;
    "gateway()": FunctionFragment;
    "owner()": FunctionFragment;
    "setSiblingChain(uint256,uint256,string,address)": FunctionFragment;
    "siblingChains(uint256)": FunctionFragment;
    "stack(uint256)": FunctionFragment;
    "transferOwnership(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "MSG_SENDER_KEY"
      | "PERCENTAGE_BASE"
      | "POSTPROCESS_SIG"
      | "batchExec"
      | "cache"
      | "execs"
      | "execute"
      | "executeWithToken"
      | "gasReceiver"
      | "gateway"
      | "owner"
      | "setSiblingChain"
      | "siblingChains"
      | "stack"
      | "transferOwnership"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "MSG_SENDER_KEY",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "PERCENTAGE_BASE",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "POSTPROCESS_SIG",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "batchExec",
    values: [
      PromiseOrValue<string>[],
      PromiseOrValue<BytesLike>[],
      PromiseOrValue<BytesLike>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "cache",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "execs",
    values: [
      PromiseOrValue<string>[],
      PromiseOrValue<BytesLike>[],
      PromiseOrValue<BytesLike>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "execute",
    values: [
      PromiseOrValue<BytesLike>,
      PromiseOrValue<string>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "executeWithToken",
    values: [
      PromiseOrValue<BytesLike>,
      PromiseOrValue<string>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<string>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "gasReceiver",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "gateway", values?: undefined): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "setSiblingChain",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "siblingChains",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "stack",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(
    functionFragment: "MSG_SENDER_KEY",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "PERCENTAGE_BASE",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "POSTPROCESS_SIG",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "batchExec", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "cache", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "execs", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "execute", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "executeWithToken",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "gasReceiver",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "gateway", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setSiblingChain",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "siblingChains",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "stack", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;

  events: {
    "LogBegin(address,bytes4,bytes)": EventFragment;
    "LogEnd(address,bytes4,bytes)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "LogBegin"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "LogEnd"): EventFragment;
}

export interface LogBeginEventObject {
  handler: string;
  selector: string;
  payload: string;
}
export type LogBeginEvent = TypedEvent<
  [string, string, string],
  LogBeginEventObject
>;

export type LogBeginEventFilter = TypedEventFilter<LogBeginEvent>;

export interface LogEndEventObject {
  handler: string;
  selector: string;
  result: string;
}
export type LogEndEvent = TypedEvent<
  [string, string, string],
  LogEndEventObject
>;

export type LogEndEventFilter = TypedEventFilter<LogEndEvent>;

export interface GTP extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: GTPInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    MSG_SENDER_KEY(overrides?: CallOverrides): Promise<[string]>;

    PERCENTAGE_BASE(overrides?: CallOverrides): Promise<[BigNumber]>;

    POSTPROCESS_SIG(overrides?: CallOverrides): Promise<[string]>;

    batchExec(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    cache(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    execs(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    execute(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    executeWithToken(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      tokenSymbol: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    gasReceiver(overrides?: CallOverrides): Promise<[string]>;

    gateway(overrides?: CallOverrides): Promise<[string]>;

    owner(overrides?: CallOverrides): Promise<[string]>;

    setSiblingChain(
      chainNumber: PromiseOrValue<BigNumberish>,
      chainId: PromiseOrValue<BigNumberish>,
      chainName: PromiseOrValue<string>,
      _gtp: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    siblingChains(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, string, string] & {
        chainId: BigNumber;
        chainName: string;
        gtp: string;
      }
    >;

    stack(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    transferOwnership(
      newOwner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  MSG_SENDER_KEY(overrides?: CallOverrides): Promise<string>;

  PERCENTAGE_BASE(overrides?: CallOverrides): Promise<BigNumber>;

  POSTPROCESS_SIG(overrides?: CallOverrides): Promise<string>;

  batchExec(
    tos: PromiseOrValue<string>[],
    configs: PromiseOrValue<BytesLike>[],
    datas: PromiseOrValue<BytesLike>[],
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  cache(
    arg0: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<string>;

  execs(
    tos: PromiseOrValue<string>[],
    configs: PromiseOrValue<BytesLike>[],
    datas: PromiseOrValue<BytesLike>[],
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  execute(
    commandId: PromiseOrValue<BytesLike>,
    sourceChain: PromiseOrValue<string>,
    sourceAddress: PromiseOrValue<string>,
    payload: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  executeWithToken(
    commandId: PromiseOrValue<BytesLike>,
    sourceChain: PromiseOrValue<string>,
    sourceAddress: PromiseOrValue<string>,
    payload: PromiseOrValue<BytesLike>,
    tokenSymbol: PromiseOrValue<string>,
    amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  gasReceiver(overrides?: CallOverrides): Promise<string>;

  gateway(overrides?: CallOverrides): Promise<string>;

  owner(overrides?: CallOverrides): Promise<string>;

  setSiblingChain(
    chainNumber: PromiseOrValue<BigNumberish>,
    chainId: PromiseOrValue<BigNumberish>,
    chainName: PromiseOrValue<string>,
    _gtp: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  siblingChains(
    arg0: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<
    [BigNumber, string, string] & {
      chainId: BigNumber;
      chainName: string;
      gtp: string;
    }
  >;

  stack(
    arg0: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  transferOwnership(
    newOwner: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    MSG_SENDER_KEY(overrides?: CallOverrides): Promise<string>;

    PERCENTAGE_BASE(overrides?: CallOverrides): Promise<BigNumber>;

    POSTPROCESS_SIG(overrides?: CallOverrides): Promise<string>;

    batchExec(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<void>;

    cache(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<string>;

    execs(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: CallOverrides
    ): Promise<void>;

    execute(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<void>;

    executeWithToken(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      tokenSymbol: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    gasReceiver(overrides?: CallOverrides): Promise<string>;

    gateway(overrides?: CallOverrides): Promise<string>;

    owner(overrides?: CallOverrides): Promise<string>;

    setSiblingChain(
      chainNumber: PromiseOrValue<BigNumberish>,
      chainId: PromiseOrValue<BigNumberish>,
      chainName: PromiseOrValue<string>,
      _gtp: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    siblingChains(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, string, string] & {
        chainId: BigNumber;
        chainName: string;
        gtp: string;
      }
    >;

    stack(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    transferOwnership(
      newOwner: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "LogBegin(address,bytes4,bytes)"(
      handler?: PromiseOrValue<string> | null,
      selector?: PromiseOrValue<BytesLike> | null,
      payload?: null
    ): LogBeginEventFilter;
    LogBegin(
      handler?: PromiseOrValue<string> | null,
      selector?: PromiseOrValue<BytesLike> | null,
      payload?: null
    ): LogBeginEventFilter;

    "LogEnd(address,bytes4,bytes)"(
      handler?: PromiseOrValue<string> | null,
      selector?: PromiseOrValue<BytesLike> | null,
      result?: null
    ): LogEndEventFilter;
    LogEnd(
      handler?: PromiseOrValue<string> | null,
      selector?: PromiseOrValue<BytesLike> | null,
      result?: null
    ): LogEndEventFilter;
  };

  estimateGas: {
    MSG_SENDER_KEY(overrides?: CallOverrides): Promise<BigNumber>;

    PERCENTAGE_BASE(overrides?: CallOverrides): Promise<BigNumber>;

    POSTPROCESS_SIG(overrides?: CallOverrides): Promise<BigNumber>;

    batchExec(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    cache(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    execs(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    execute(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    executeWithToken(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      tokenSymbol: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    gasReceiver(overrides?: CallOverrides): Promise<BigNumber>;

    gateway(overrides?: CallOverrides): Promise<BigNumber>;

    owner(overrides?: CallOverrides): Promise<BigNumber>;

    setSiblingChain(
      chainNumber: PromiseOrValue<BigNumberish>,
      chainId: PromiseOrValue<BigNumberish>,
      chainName: PromiseOrValue<string>,
      _gtp: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    siblingChains(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    stack(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    transferOwnership(
      newOwner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    MSG_SENDER_KEY(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    PERCENTAGE_BASE(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    POSTPROCESS_SIG(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    batchExec(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    cache(
      arg0: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    execs(
      tos: PromiseOrValue<string>[],
      configs: PromiseOrValue<BytesLike>[],
      datas: PromiseOrValue<BytesLike>[],
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    execute(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    executeWithToken(
      commandId: PromiseOrValue<BytesLike>,
      sourceChain: PromiseOrValue<string>,
      sourceAddress: PromiseOrValue<string>,
      payload: PromiseOrValue<BytesLike>,
      tokenSymbol: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    gasReceiver(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    gateway(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    owner(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    setSiblingChain(
      chainNumber: PromiseOrValue<BigNumberish>,
      chainId: PromiseOrValue<BigNumberish>,
      chainName: PromiseOrValue<string>,
      _gtp: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    siblingChains(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    stack(
      arg0: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    transferOwnership(
      newOwner: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
