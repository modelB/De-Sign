// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/// @custom:security-contact bgro63@gmail.com
contract DeSign is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    using Strings for address;

    Counters.Counter private _tokenIdCounter;

    struct Contract {
        uint256 tokenId;
        string buyer_name;
        uint256 buyer_sign_date;
        address buyer_wallet_address;
        string seller_name;
        uint256 seller_sign_date;
        address seller_wallet_address;
        string product;
        string price;
        string contract_date;
    }

    mapping(uint256 => Contract) public tokenIdToContract;

    constructor() ERC721("de|sign", "SIGN") {}

    function generateImage(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        Contract memory sourceContract = tokenIdToContract[tokenId];
        bytes memory svg = abi.encodePacked(
            string.concat(
                '<svg width="600" height="800" viewBox="0 0 600 800" fill="none" xmlns="http://www.w3.org/2000/svg"><style>.base { fill: black; font-family: serif; font-size: 14px; } .title { font-size: 30px } .bold { font-weight: bold } .tiny { font-size: 12px; margin-top: 8px } p { margin: 0 } .flex { width: 100%; display: flex; justify-content: space-around } .margin-top-8 { margin-top: 8px } .margin-top-4 { margin-top: 4px } .italic { font-style: italic; } .underline { text-decoration: underline }</style><rect width="600" height="800" fill="#fff" /><path xmlns="http://www.w3.org/2000/svg" d="M65.5 24C64.1383 25.3033 62.5184 26.3065 60.745 26.945C58.875 27.275 53.7 24.875 51.15 27.325C50.725 27.75 50.2 28.175 49.65 28.6C48.45 28.075 46.6 27.275 45.25 26.5C43.9 25.725 40.5 24 40.5 24L33 32.75C33 32.75 34.85 35.25 36 36.9C36.75 38 37.675 39.675 38.275 40.8L37.425 41.8C37.2214 42.2044 37.1482 42.6619 37.2154 43.1096C37.2825 43.5573 37.4868 43.9732 37.8 44.3C38.1616 44.5711 38.6015 44.7172 39.0533 44.7163C39.5052 44.7154 39.9445 44.5675 40.305 44.295C40.1713 44.4515 40.0702 44.633 40.0074 44.829C39.9447 45.025 39.9216 45.2316 39.9395 45.4366C39.9574 45.6416 40.016 45.841 40.1118 46.0232C40.2076 46.2053 40.3387 46.3666 40.4975 46.4975C40.8793 46.7205 41.3136 46.8375 41.7557 46.8367C42.1978 46.8358 42.6316 46.717 43.0125 46.4925C42.7269 46.8485 42.5706 47.291 42.5692 47.7474C42.5678 48.2039 42.7215 48.6473 43.005 49.005C43.3735 49.1326 43.7666 49.1732 44.1534 49.1238C44.5402 49.0744 44.9104 48.9362 45.235 48.72C45.0733 49.1027 45.0314 49.5255 45.1149 49.9326C45.1983 50.3396 45.4032 50.7118 45.7025 51C46.1253 51.1879 46.5888 51.2653 47.0497 51.2251C47.5106 51.1848 47.9537 51.0283 48.3375 50.77L49.6275 49.6025C50.8075 50.7775 52.435 51.505 54.2325 51.505L54.385 51.5025C54.9774 51.4519 55.5448 51.2412 56.0266 50.8929C56.5084 50.5445 56.8863 50.0717 57.12 49.525C57.485 49.665 57.9 49.76 58.34 49.76C58.93 49.76 59.4775 49.59 59.94 49.2975C61.4025 48.33 61.0525 47.58 61.0525 47.58C61.5725 47.8039 62.1502 47.8569 62.7023 47.7316C63.2545 47.6063 63.7526 47.309 64.125 46.8825C64.512 46.4866 64.756 45.973 64.8185 45.4229C64.881 44.8728 64.7584 44.3176 64.47 43.845C64.4858 43.8544 64.5041 43.8588 64.5225 43.8575C65.575 43.8575 66.49 43.2775 66.9675 42.4225C67.2025 41.8148 67.2819 41.1581 67.1985 40.5119C67.1151 39.8657 66.8716 39.2506 66.49 38.7225L66.4975 38.735C68.5475 38.335 68.4725 37.31 69.4725 35.81C70.4193 34.5859 71.5975 33.5598 72.94 32.79L65.5 24ZM65.375 41.65C64.275 42.75 63.425 42.275 61.55 40.85C59.675 39.425 55.95 36.75 55.95 36.75C56.1025 37.5125 56.455 38.175 56.9525 38.7025C57.75 39.6 60.125 41.65 61.25 42.7C61.95 43.35 63.75 44.65 62.7 45.65C61.65 46.65 60.825 45.65 59.1 44.25C57.375 42.85 53.525 39.4 53.525 39.4C53.5038 39.7307 53.553 40.0621 53.6693 40.3724C53.7857 40.6827 53.9666 40.9648 54.2 41.2C54.625 41.7 57 44 58 45.05C59 46.1 59.875 46.725 59.025 47.55C58.175 48.375 56.45 47.075 55.5 46.1C54.025 44.675 51.1 42.025 51.1 42.025L51.0975 42.1575C51.0975 42.8675 51.3425 43.5175 51.755 44.0325C52.475 44.9775 53.875 46.2025 54.725 47.1525C55.575 48.1025 56.075 48.9025 54.725 49.6525C53.375 50.4025 51.375 48.5525 50.5 47.6525V47.6475C50.5002 47.4006 50.4114 47.1618 50.25 46.975C49.951 46.698 49.582 46.5078 49.1829 46.425C48.7837 46.3422 48.3696 46.3698 47.985 46.505C48.1432 46.3633 48.2701 46.1901 48.3574 45.9965C48.4447 45.8029 48.4905 45.5932 48.4919 45.3808C48.4933 45.1684 48.4503 44.9581 48.3656 44.7634C48.2809 44.5686 48.1563 44.3938 48 44.25C47.6718 44.0014 47.2713 43.867 46.8596 43.8675C46.4479 43.8679 46.0476 44.0031 45.72 44.2525C45.8857 44.0943 46.0135 43.9007 46.0941 43.6863C46.1747 43.4719 46.206 43.242 46.1856 43.0138C46.1652 42.7857 46.0936 42.565 45.9762 42.3683C45.8588 42.1716 45.6986 42.0038 45.5075 41.8775C45.06 41.5963 44.5348 41.4642 44.0075 41.5001C43.4801 41.536 42.9778 41.7382 42.5725 42.0775C42.8434 41.7492 42.9769 41.329 42.9452 40.9046C42.9135 40.4802 42.7191 40.0844 42.4025 39.8C42.009 39.4338 41.5076 39.2047 40.9732 39.147C40.4388 39.0893 39.9 39.2062 39.4375 39.48L37.775 36.6725C36.625 34.8475 35.275 32.9475 35.275 32.9475L40.975 26.0225C40.975 26.0225 43 27.2725 44.675 28.2225C45.5 28.6975 46.925 29.3225 48 29.8225C46.3 31.0975 44.875 32.3225 45.3 33.1725C46.0574 33.7162 46.9625 34.0161 47.8947 34.0322C48.8269 34.0482 49.7418 33.7797 50.5175 33.2625C51.5121 32.6013 52.6807 32.2506 53.875 32.255C54.7425 32.255 55.5675 32.435 56.315 32.7625C57.7 33.6975 60.25 35.9975 62.575 37.4475C65.5 39.5725 66.075 40.9475 65.375 41.6475V41.65Z" fill="#D50101"/><text x="50%" y="5%" class="base title bold" dominant-baseline="middle" text-anchor="middle">Sales Contract</text><text x="87%" y="5%" class="base" dominant-baseline="middle" text-anchor="middle">de-signature.xyz</text><foreignObject x="5%" y="8%" width="90%" height="90%"><div xmlns="http://www.w3.org/1999/xhtml" class="base">',
                '<p class="tiny">THIS SALES CONTRACT (this "Agreement" or this "Sales Contract"), effective as of ',
                sourceContract.contract_date,
                ", is made and entered into by and between ",
                sourceContract.seller_name,
                ", an individual controlling the Ethereum wallet address of ",
                sourceContract.seller_wallet_address.toHexString(),
                ' (hereinafter the "Seller"), and ',
                sourceContract.buyer_name,
                ", an individual controlling the Ethereum wallet address of "
            ),
            string.concat(
                sourceContract.buyer_wallet_address.toHexString(),
                ' (hereinafter the "Buyer"). Buyer agrees to pay seller consideration of ',
                sourceContract.price,
                ' and in exchange Seller agrees to provide buyer with ',
                sourceContract.product,
                '.</p><p class="tiny">1. APPLICABILITY. The Buyer may place orders ("Order(s)") with Seller and all such Orders will be governed solely by the terms in this Sales Contract, unless otherwise mutually agreed. Any oral understandings are expressly excluded.</p><p class="tiny">2. DELIVERY. Delivery shall be made within the time specified. Transportation charges are included in the prices quoted herein and as such the responsibility of Seller.</p><p class="tiny">3. INSPECTION. The Buyer shall inspect and accept, or reject products delivered pursuant to the Order immediately after Buyer takes custody of such products.</p><p class="tiny">4. PRICES AND PAYMENT. Prices and payments will be in United States dollars, and payment shall be made in the United States currency or Ethereum mainnet ether. Payment is due immediately upon delivery. In the event payments are not made in a timely manner, Seller may, in addition to all other remedies provided at law, charge interest on the delinquency at a rate of 5% per month or the maximum rate permittedby law, if lower, for each month or part thereof of delinquency in payment.</p><p class="tiny">5. CANCELLATION. Buyer reserves the right to cancel any portion of this Order affected by a default of Seller or any insolvency or suspension of Seller operations or any petition led or proceeding commenced by or against Seller under any state or federal law relating to bankruptcy, arrangement, reorganization, receivership or assignment for the benefit of creditors.</p><p class="tiny">6. DISPUTES. Except as otherwise specically agreed in writing by Buyer and Seller, any dispute relating to an Order placed by a Buyer incorporated in the United States which is not resolved by the parties shall be adjudicated by any court of competent jurisdiction. For Orders placed by a Buyer incorporated outside the United States, the parties shall resort to binding arbitration under mutually agreed procedures.</p><p class="tiny">7. APPLICABLE LAW. This Agreement shall be interpreted in accordance with the laws of the jurisdiction in which the Seller facility accepting the Order hereunder is located, exclusive of any choice of law provisions. The Seller and Buyer expressly agree to exclude from this Agreement the United Nations Convention on Contracts for the International Sale of Goods, 1980, and any successor thereto.</p><p class="tiny">8. LIMITATION OF LIABILITY. Seller liability on any claim for loss or damage arising out of, connected with, or resulting from an Order, or from the performance or breach thereof, or from the manufacture, sale, delivery, resale, repair or use of any product covered by or furnished under an Order shall in no case exceed the price allocable to the product or part thereof which gives rise to the claim. In no event shall Seller be liable for special, incidental or consequential damages. Except as herein expressly provided to the contrary, the provisions of this Order are for the benefit of the parties to the Order only.</p><p class="tiny">9. TAXES. The prices quoted herein include sales taxes. As such they are the responsibility of Seller.</p><div class="flex margin-top-8"><div><p>Buyer Signature:</p><p class="italic underline margin-top-8">',
                sourceContract.buyer_sign_date != 0 ? sourceContract.buyer_name : "_______",
                "</p><p>Timestamp: ",
                sourceContract.buyer_sign_date.toString()
            ),
            string.concat(
                '</p></div><div><p>Seller Signature:</p><p class="italic underline margin-top-8">',
                sourceContract.seller_sign_date != 0 ? sourceContract.seller_name : "_______",
                "</p><p>Timestamp: ",
                sourceContract.seller_sign_date.toString(),
                "</p></div></div></div></foreignObject></svg>"
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "De|Sign Contract #',
            tokenId.toString(),
            '",',
            '"description": "A legally binding contract, published to the blockchain for eternity as an NFT | de-signature.xyz",',
            '"image": "',
            generateImage(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint(
        string memory buyer_name,
        address buyer_wallet_address,
        string memory seller_name,
        address seller_wallet_address,
        string memory product,
        string memory price,
        string memory contract_date
    ) public {
        address emptyAddress = address(0);
        require(
            seller_wallet_address != emptyAddress &&
                buyer_wallet_address != emptyAddress,
            "A buyer and seller wallet address must be provided"
        );
        require(
            msg.sender == seller_wallet_address ||
                msg.sender == buyer_wallet_address,
            "Only the buyer or seller can mint the contract"
        );
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        Contract memory newContract = Contract(
            tokenId,
            buyer_name,
            0,
            buyer_wallet_address,
            seller_name,
            0,
            seller_wallet_address,
            product,
            price,
            contract_date
        );
        tokenIdToContract[tokenId] = newContract;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function updateContract(
        uint256 tokenId,
        string memory price,
        string memory contract_date
    ) public {
        require(_exists(tokenId), "This NFT contract does not exist");
        Contract memory existingContract = tokenIdToContract[tokenId];
        require(
            existingContract.seller_sign_date == 0 &&
                existingContract.buyer_sign_date == 0,
            "Cannot update a contract that has been signed"
        );
        require(
            existingContract.buyer_wallet_address == msg.sender ||
                existingContract.seller_wallet_address == msg.sender,
            "Must be buyer or seller to update contract"
        );
        existingContract.price = price;
        existingContract.contract_date = contract_date;
        tokenIdToContract[tokenId] = existingContract;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function signContract(uint256 tokenId) public {
        require(_exists(tokenId), "This NFT contract does not exist");
        Contract memory existingContract = tokenIdToContract[tokenId];
        require(
            existingContract.buyer_wallet_address == msg.sender ||
                existingContract.seller_wallet_address == msg.sender,
            "Must be buyer or seller to sign contract"
        );
        if (existingContract.buyer_wallet_address == msg.sender) {
            require(
                existingContract.buyer_sign_date == 0,
                "Contract has already been signed"
            );
            existingContract.buyer_sign_date = block.timestamp;
        } else if (existingContract.seller_wallet_address == msg.sender) {
            require(
                existingContract.seller_sign_date == 0,
                "Contract has already been signed"
            );
            existingContract.seller_sign_date = block.timestamp;
        }
        tokenIdToContract[tokenId] = existingContract;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
